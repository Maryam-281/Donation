//
//  DonationFilter.swift
//  Donation
//
//  Created by macOS on 22/12/2025.
//

import UIKit
import Foundation
import DGCharts


class DonationFilter: UIViewController {
    
    
    
    // initialze radio buttons
    @IBOutlet weak var last10DaysButton: UIButton!
    @IBOutlet weak var customRangeButton: UIButton!
    
    //initialize
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var linerChart: LineChartView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    let currentUser = "testing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // funation to unselect the radio buttons when loading
    func setupRadioButtons() {
        last10DaysButton.isSelected = false
        customRangeButton.isSelected = false
    }
    
    // function to return the sender selection
    @IBAction func radioButtonTapped(_ sender: UIButton) {
        if sender == last10DaysButton {
                last10DaysButton.isSelected = true
                customRangeButton.isSelected = false
            } else if sender == customRangeButton {
                last10DaysButton.isSelected = false
                customRangeButton.isSelected = true
            }
    }
    
    //Filter Button to update chart
    @IBAction func filterBtnClicked(_ sender: UIButton) {
        var startDate: Date
            var endDate: Date

            // Determine which filter is selected
            if last10DaysButton.isSelected {
                endDate = Date() // today
                startDate = Calendar.current.date(byAdding: .day, value: -10, to: endDate)!
            } else if customRangeButton.isSelected {
                startDate = fromDatePicker.date
                endDate = toDatePicker.date
                
                // Validate date range
                guard startDate <= endDate else {
                    print("❌ Start date must be before end date")
                    return
                }
            } else {
                print("❌ Please select a filter option")
                return
            }

            // Call chart loading function with user
            loadLinerChartData(startDate: startDate, endDate: endDate, user: currentUser)

            // Update button UI
            sender.isSelected = true
        }
    
    @IBAction func resetBtnClicked(_ sender: UIButton) {
        // 1️⃣ Clear chart data
           linerChart.data = nil
           linerChart.notifyDataSetChanged()  // ensures chart redraws empty state

           // 2️⃣ Deselect radio buttons
           last10DaysButton.isSelected = false
           customRangeButton.isSelected = false

           // 3️⃣ Reset date pickers to today
           let today = Date()
           fromDatePicker.setDate(today, animated: true)
           toDatePicker.setDate(today, animated: true)

           // 4️⃣ Optionally, mark the reset button as selected
           sender.isSelected = true
        
    }
    
    struct MonthlyDonation: Decodable {
        let month_start: String
        let donation_count: Int
    }
    
    func loadLinerChartData(startDate: Date, endDate: Date, user: String) {
        Task {
            do {
                // 1️⃣ Format dates for SQL
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                
                let startDateString = dateFormatter.string(from: startDate)
                let endDateString = dateFormatter.string(from: endDate)
                
                // 2️⃣ Call Supabase RPC with user parameter
                let response = try await SupabaseManager.shared.client
                    .rpc("get_monthly_donations_range_user", params: [
                        "start_date": startDateString,
                        "end_date": endDateString,
                        "p_user": user   // matches the renamed SQL parameter
                    ])
                    .execute()
                
                // 3️⃣ Decode response
                let decoded: [MonthlyDonation] = try JSONDecoder().decode([MonthlyDonation].self, from: response.data)
                
                // 4️⃣ Map month → donation count
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
                
                // 8️⃣ Assign chart data
                linerChart.data = LineChartData(dataSet: dataset)
                linerChart.animate(yAxisDuration: 1.0)
                
                // 9️⃣ Configure x-axis
                let xAxis = linerChart.xAxis
                xAxis.labelPosition = .bottom
                xAxis.granularity = 30 * 24 * 60 * 60 // roughly 1 month
                
                if let first = monthDates.first, let last = monthDates.last {
                    xAxis.axisMinimum = first.timeIntervalSince1970
                    xAxis.axisMaximum = Calendar.current.date(byAdding: .month, value: 1, to: last)!.timeIntervalSince1970
                }
                
                // Format x-axis labels
                xAxis.valueFormatter = MonthYearValueFormatter()
                
                // Configure legend
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
