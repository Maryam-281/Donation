//
//  userAnalytixDashboard.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import UIKit
import Foundation
import DGCharts

class userAnalyticsDashboard: UIViewController {

    @IBOutlet weak var donationView: UIView!
    @IBOutlet weak var donationSuportView: UIView!
    @IBOutlet weak var donationMonthlyChartBorderView: UIView!
    @IBOutlet weak var donationYearlyChartBorderView: UIView!
    @IBOutlet weak var monthlyDonationChart: LineChartView!
    @IBOutlet weak var yearDonationChart: LineChartView!
    @IBOutlet weak var allDonations: UILabel!
    @IBOutlet weak var supportedDonations: UILabel!
    
//    var ID = userid?
    let userID = "8117c537-a552-41ea-900c-afda164ac967"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toDonationFilter" {

            // 1️⃣ Get the navigation controller
            let navController = segue.destination as! UINavigationController

            // 2️⃣ Get the actual destination VC
            let secondVC = navController.topViewController as! DonationFilter

            // 3️⃣ Pass the data
            secondVC.userId = userID
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        donationView.layer.borderColor = UIColor.lightGray.cgColor
        donationSuportView.layer.borderColor = UIColor.lightGray.cgColor
        donationMonthlyChartBorderView.layer.borderColor = UIColor.lightGray.cgColor
        donationYearlyChartBorderView.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
        loadLineMonthlyData(donorId: userID)
        loadLinerYearlyData(donorId: userID)
        fetchCountDonation()
        fetchCountDonationInYear()
    }
    struct Donations: Codable {
        let donationid: Int
    }
    struct DonationCompleted: Codable {
        let donationid: Int
    }
    struct MonthlyDonation: Decodable {
        let month_start: String
        let donation_count: Int
    }

    struct YearlyDonation: Decodable {
        let month_start: String
        let donation_count: Int
    }
    func fetchCountDonation()
    {

         Task {
             do {
                 let response = try await SupabaseManager.shared.client
                     .from("Donation_history")
                     .select("donationid", count: .exact )
                     .eq("donor_id", value: userID)
                     .execute()
                 let val = response.data
                 let decoded = try JSONDecoder().decode([Donations].self, from: val)
                 allDonations.text =  String (decoded.count)
             } catch {
                    print("❌ Supabase error:", error)
                }
            }
        }
    func fetchCountDonationInYear() {
        Task {
            do {
                // 1️⃣ Get current year as a string
                let calendar = Calendar.current
                let year = calendar.component(.year, from: Date())
                
                // 2️⃣ Fetch donations with Supabase filter
                let response = try await SupabaseManager.shared.client
                    .from("Donation_history")
                    .select("donationid", count: .exact)
                    .eq("donor_id", value: userID)
                    .eq("status", value: "Completed")
                    .gte("date", value: "\(year)-01-01")  // greater than Jan 1 of current year
                    .lte("date", value: "\(year)-12-31")  // less than Dec 31 of current year
                    .execute()
                
                // 3️⃣ Get count from response
                let val = response.data
                let decoded = try JSONDecoder().decode([DonationCompleted].self, from: val)
                supportedDonations.text = String(decoded.count)
                
            } catch {
                print("❌ Supabase error:", error)
            }
        }
    }
    func loadLineMonthlyData(donorId: String) {
        Task {
            do {
                // 1️⃣ Call Supabase RPC with donor_id (UUID)
                let response = try await SupabaseManager.shared.client
                    .rpc(
                        "get_monthly_donations_user",
                        params: ["p_donor_id": donorId]
                    )
                    .execute()

                // 2️⃣ Decode response
                let decoded = try JSONDecoder().decode([MonthlyDonation].self, from: response.data)

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "MMM"
                displayFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                var monthLabels: [String] = []
                var entries: [ChartDataEntry] = []

                for (index, donation) in decoded.enumerated() {
                    if let date = dateFormatter.date(from: donation.month_start) {
                        monthLabels.append(displayFormatter.string(from: date))

                        entries.append(
                            ChartDataEntry(
                                x: Double(index),
                                y: Double(donation.donation_count)
                            )
                        )
                    }
                }

                // 3️⃣ Create dataset
                let dataset = LineChartDataSet(entries: entries, label: "Donations")
                dataset.colors = [.systemBlue]
                dataset.circleColors = [.systemBlue]
                dataset.circleRadius = 5
                dataset.lineWidth = 2
                dataset.drawValuesEnabled = true

                // 4️⃣ Assign chart data
                let data = LineChartData(dataSet: dataset)
                monthlyDonationChart.data = data
                monthlyDonationChart.animate(yAxisDuration: 1.0)
                monthlyDonationChart.rightAxis.enabled = false

                // 5️⃣ Configure x-axis
                let xAxis = monthlyDonationChart.xAxis
                xAxis.valueFormatter = IndexAxisValueFormatter(values: monthLabels)
                xAxis.granularity = 1
                xAxis.labelPosition = .bottom
                xAxis.drawGridLinesEnabled = false

                // Legend
                let legend = monthlyDonationChart.legend
                legend.enabled = true
                legend.horizontalAlignment = .right
                legend.verticalAlignment = .top
                legend.orientation = .horizontal
                legend.drawInside = false

            } catch {
                print("❌ Supabase error:", error)
            }
        }
    }
    func loadLinerYearlyData(donorId: String) {
        Task {
            do {
                // 1️⃣ Call Supabase RPC with donor_id (UUID)
                let response = try await SupabaseManager.shared.client
                    .rpc(
                        "get_monthly_donations_year_user",
                        params: ["p_donor_id": donorId]
                    )
                    .execute()

                let decoded: [YearlyDonation] =
                    try JSONDecoder().decode([YearlyDonation].self, from: response.data)

                // 2️⃣ Date formatter (MATCH SQL FORMAT)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")

                // 3️⃣ Map month → count
                var monthDict: [Date: Double] = [:]
                for donation in decoded {
                    if let date = dateFormatter.date(from: donation.month_start) {
                        monthDict[date] = Double(donation.donation_count)
                    }
                }

                // 4️⃣ Sort months
                let monthDates = monthDict.keys.sorted()

                // 5️⃣ Create chart entries
                let entries: [ChartDataEntry] = monthDates.map { date in
                    ChartDataEntry(
                        x: date.timeIntervalSince1970,
                        y: monthDict[date] ?? 0
                    )
                }

                // 6️⃣ Dataset
                let dataset = LineChartDataSet(entries: entries, label: "Donations")
                dataset.colors = [.systemBlue]
                dataset.circleColors = [.systemBlue]
                dataset.circleRadius = 5
                dataset.lineWidth = 2
                dataset.mode = .cubicBezier
                dataset.drawValuesEnabled = true

                // 7️⃣ Assign data
                yearDonationChart.data = LineChartData(dataSet: dataset)
                yearDonationChart.animate(yAxisDuration: 1.0)

                // 8️⃣ Chart config
                yearDonationChart.rightAxis.enabled = false
                yearDonationChart.legend.enabled = true

                // 9️⃣ X-axis formatting (YEAR–MONTH)
                let xAxis = yearDonationChart.xAxis
                xAxis.labelPosition = .bottom
                xAxis.granularity = 30 * 24 * 60 * 60 // ~1 month
                xAxis.valueFormatter = MonthYearValueFormatter()

                // Legend
                let legend = yearDonationChart.legend
                legend.enabled = true
                legend.horizontalAlignment = .right
                legend.verticalAlignment = .top
                legend.orientation = .horizontal
                legend.drawInside = false

            } catch {
                print("❌ Supabase error:", error)
            }
        }
    }

}
