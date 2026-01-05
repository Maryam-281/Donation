//
//  adminHomeViewController.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import UIKit
import Foundation
import DGCharts

class adminHomeViewController: UIViewController {
    @IBOutlet weak var donationView: UIView!
    @IBOutlet weak var donationSuportView: UIView!
    @IBOutlet weak var donationMonthlyChartBorderView: UIView!
    @IBOutlet weak var donationYearlyChartBorderView: UIView!
    @IBOutlet weak var monthlyDonationChart: LineChartView!
    @IBOutlet weak var yearDonationChart: LineChartView!
    @IBOutlet weak var allDonations: UILabel!
    @IBOutlet weak var supportedDonations: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donationView.layer.borderColor = UIColor.lightGray.cgColor
        donationSuportView.layer.borderColor = UIColor.lightGray.cgColor
        donationMonthlyChartBorderView.layer.borderColor = UIColor.lightGray.cgColor
        donationYearlyChartBorderView.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
        loadLineMonthlyData()
        loadLinerYearlyData()
        fetchCount()
        fetchCountDonationInYear()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            performSegue(withIdentifier: "homeToDonations", sender: self)
        case 2:
            performSegue(withIdentifier: "homeToFeedback", sender: self)
        default:
            break
        }
    }
    struct Donation_history: Codable {
        let donationid: Int
    }
    struct DonationCompleted: Codable {
        let donationid: Int
    }
    struct WeeklyDonation: Codable {
        let week_start: String
        let donation_count: Int
    }
    struct MonthlyDonation: Decodable {
        let month_start: String
        let donation_count: Int
    }
    func fetchCount()
    {
        Task {
            do {
                let response = try await SupabaseManager.shared.client
                    .from("Donation_history")
                    .select("donationid", count: .exact )
                    .execute()
                let val = response.data
                let decoded = try JSONDecoder().decode([Donation_history].self, from: val)
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
    func loadLineMonthlyData() {
        Task {
            do {
                // 1️⃣ Call the Supabase RPC function
                let response = try await SupabaseManager.shared.client
                    .rpc("get_weekly_donations")
                    .execute()
                let decoded = try JSONDecoder().decode([WeeklyDonation].self, from: response.data)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "MMM d"
                displayFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                var weekLabels: [String] = []
                var entries: [ChartDataEntry] = []

                for (index, donation) in decoded.enumerated() {
                    if let startDate = dateFormatter.date(from: donation.week_start),
                       let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate) {

                        let label = "\(displayFormatter.string(from: startDate))-\(displayFormatter.string(from: endDate))"
                        weekLabels.append(label)

                        entries.append(
                            ChartDataEntry(
                                x: Double(index),
                                y: Double(donation.donation_count)
                            )
                        )
                    }
                }

                // 6️⃣ Create dataset
                let dataset = LineChartDataSet(entries: entries, label: "Donations")
                dataset.colors = [.systemBlue]
                dataset.circleColors = [.systemBlue]
                dataset.circleRadius = 5
                dataset.lineWidth = 2
                dataset.drawValuesEnabled = true
                // 7️⃣ Setup chart data
                let data = LineChartData(dataSet: dataset)
                monthlyDonationChart.data = data
                monthlyDonationChart.animate(yAxisDuration: 1.0)
                monthlyDonationChart.rightAxis.enabled = false
                monthlyDonationChart.legend.enabled = true
                // 8️⃣ Configure x-axis to show formatted dates
                let xAxis = monthlyDonationChart.xAxis
                xAxis.valueFormatter = IndexAxisValueFormatter(values: weekLabels)
                xAxis.granularity = 1
                xAxis.granularityEnabled = true
                xAxis.labelPosition = .bottom
                xAxis.drawGridLinesEnabled = false
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
    func loadLinerYearlyData() {
        Task {
            do {
                // 1️⃣ Fetch data
                let response = try await SupabaseManager.shared.client
                    .rpc("get_monthly_donations_year")
                    .execute()

                let decoded: [MonthlyDonation] =
                    try JSONDecoder().decode([MonthlyDonation].self, from: response.data)

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
                xAxis.granularity = 30 * 24 * 60 * 60
                xAxis.valueFormatter = MonthYearValueFormatter()
                
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
final class MonthYearValueFormatter: AxisValueFormatter {

    private let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yy-MM"
        return df
    }()

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return formatter.string(from: date)
    }
}
