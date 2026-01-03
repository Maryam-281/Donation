//
//  adminDonationsViewController.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import UIKit
import Foundation
import DGCharts



class adminDonationsViewController: UIViewController {
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var filterButten: UIButton!
    @IBOutlet weak var linerChart: LineChartView!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.performSegue(withIdentifier: "donationsToHome", sender: self)
            break
        case 2:
            self.performSegue(withIdentifier: "donationsToFeedback", sender: self)
            break
        default:
            break
        }
    }
    
    struct MonthlyDonation: Decodable {
        let month_start: String
        let donation_count: Int
    }
    
    @IBAction func filterbtnClicked(_ sender: UIButton) {
            // 1️⃣ Get dates from UI
            let startDate = fromDatePicker.date
            let endDate = toDatePicker.date
            
            // 2️⃣ Validate dates
            guard startDate <= endDate else {
                print("❌ Start date must be before end date")
                return
            }
            
            // 3️⃣ Load chart data for the selected range
            loadLinerChartData(startDate: startDate, endDate: endDate)
            
            // 4️⃣ Update button state
            sender.isSelected = true
    }
    
    @IBAction func resetBtnClicked(_ sender: UIButton) {
        linerChart.data = nil
        fromDatePicker.setDate(Date(), animated: true)
        toDatePicker.setDate(Date(), animated: true)
        sender.isSelected = true
    }
 
    func loadLinerChartData(startDate: Date, endDate: Date) {
        Task {
            do {
                // 1️⃣ Format dates as "yyyy-MM-dd" to match SQL
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                
                let startDateString = dateFormatter.string(from: startDate)
                let endDateString = dateFormatter.string(from: endDate)
                
                // 2️⃣ Call Supabase RPC with parameters
                let response = try await SupabaseManager.shared.client
                    .rpc("get_monthly_donations_range", params: [
                        "start_date": startDateString,
                        "end_date": endDateString
                    ])
                    .execute()
                
                // 3️⃣ Decode response
                let decoded: [MonthlyDonation] = try JSONDecoder().decode([MonthlyDonation].self, from: response.data)
                
                // 4️⃣ Map month → count
                var monthDict: [Date: Double] = [:]
                for donation in decoded {
                    if let date = dateFormatter.date(from: donation.month_start) {
                        monthDict[date] = Double(donation.donation_count)
                    }
                }
                
                // 5️⃣ Sort months
                let monthDates = monthDict.keys.sorted()

                // 6️⃣ Create chart entries
                let entries: [ChartDataEntry] = monthDates.map { date in
                    ChartDataEntry(
                        x: date.timeIntervalSince1970,
                        y: monthDict[date] ?? 0
                    )
                }

                // 7️⃣ Create dataset
                let dataset = LineChartDataSet(entries: entries, label: "Donations")
                dataset.colors = [.systemBlue]
                dataset.circleColors = [.systemBlue]
                dataset.circleRadius = 5
                dataset.lineWidth = 2
                dataset.mode = .cubicBezier
                dataset.drawValuesEnabled = true
                
                // 8️⃣ Assign data
                linerChart.data = LineChartData(dataSet: dataset)
                linerChart.animate(yAxisDuration: 1.0)

                // 9️⃣ Configure x-axis
                let xAxis = linerChart.xAxis
                xAxis.labelPosition = .bottom
                xAxis.granularity = 30 * 24 * 60 * 60 // roughly 1 month

                // ⚡ Ensure chart covers the full range including last month
                if let first = monthDates.first, let last = monthDates.last {
                    xAxis.axisMinimum = first.timeIntervalSince1970
                    xAxis.axisMaximum = Calendar.current.date(byAdding: .month, value: 1, to: last)!.timeIntervalSince1970
                }

                // Format x-axis labels
                xAxis.valueFormatter = MonthYearValueFormatter()
                
                let legend = linerChart.legend
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
