//
//  adminFeedbackViewController.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import UIKit
import Foundation
import SwiftUI
import DGCharts

class adminFeedbackViewController: UIViewController {
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var hygineRate: UILabel!
    @IBOutlet weak var pickUpTimeRate: UILabel!
    @IBOutlet weak var packagingRate: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPieChart()
        hygienePercent()
        pickUpPercent()
        PackagingPercent()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func applybtnClicked(_ sender: UIButton) {
        // 1️⃣ Get dates from UI
        let startDate = fromDatePicker.date
        let endDate = toDatePicker.date
        
        // 2️⃣ Validate dates
        guard startDate <= endDate else {
            print("❌ Start date must be before end date")
            return
        }
        fetchComments(startDate: startDate, endDate: endDate) { comments in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if comments.isEmpty {
                    self.feedbackLabel.text = "No comments in this period."
                } else {
                    self.feedbackLabel.numberOfLines = 0
                    self.feedbackLabel.lineBreakMode = .byWordWrapping
                    self.feedbackLabel.text = comments.joined(separator: "\n\n")
                    scrollView.setContentOffset(.zero, animated: false)
                    
//                    for (index, value) in comments.enumerated() {
//                        if  self.feedbackLabel == scrollView.viewWithTag(index) as? UILabel {
//                                self.feedbackLabel.text = value
//                            }
//                        }
                    
                
                }
            }
        }
            sender.isSelected = true
      }
    @IBAction func clearBtnClicked(_ sender: UIButton) {
        feedbackLabel.text = ""
                scrollView.setContentOffset(.zero, animated: true)
        fromDatePicker.setDate(Date(), animated: true)
        toDatePicker.setDate(Date(), animated: true)
        sender.isSelected = true
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.performSegue(withIdentifier: "feedbackToHome", sender: self)
            break
        case 1:
            self.performSegue(withIdentifier: "feedbackToDonations", sender: self)
            break
        default:
            break
        }
    }
    
    struct DonationStatus: Codable {
        let status: String
        let count: Int
    }
    struct hygineFeedback: Codable {
        let hygieneRate: Int
    }
    struct pickUpTimeFeedback: Codable {
        let pickupTime: Int
    }
    struct packagingFeedback: Codable {
        let packagingRate: Int
    }
    struct FeedbackRow: Codable {
        let comment: String
    }

    func fetchComments(startDate: Date, endDate: Date, completion: @escaping ([String]) -> Void) {
        Task {
            do {
                // 1️⃣ Call Supabase RPC and execute
                let response = try await SupabaseManager.shared.client
                    .rpc("get_feedback_comments_by_date", params: [
                        "start_date": startDate,
                        "end_date": endDate
                    ])
                    .execute() // ✅ must call execute()
                // 2️⃣ Decode raw data into FeedbackRow array
                let feedbackRows = try JSONDecoder().decode([FeedbackRow].self, from: response.data)
                // 3️⃣ Map to string array
                let comments = feedbackRows.map { $0.comment }
                completion(comments)
            } catch {
                print("Error fetching comments:", error)
                completion([])
            }
        }
    }
        
    func setupPieChart() {
        Task {
            do {
                // 1️⃣ Fetch status counts from Supabase
                let response = try await SupabaseManager.shared.client
                    .rpc("get_donation_status_counts") // no user_id, all users
                    .execute()
                
                let statuses = try JSONDecoder().decode([DonationStatus].self, from: response.data)
                
                // 2️⃣ Map to PieChartDataEntry
                let entries = statuses.map { status in
                    PieChartDataEntry(value: Double(status.count), label: status.status)
                }
                
                // 3️⃣ Setup dataset
                let dataset = PieChartDataSet(entries: entries)
                dataset.colors = ChartColorTemplates.material()
                
                // 4️⃣ Assign data to chart
                let data = PieChartData(dataSet: dataset)
                pieChartView.data = data
                
                // 5️⃣ Chart styling
                pieChartView.holeRadiusPercent = 0.4
                pieChartView.animate(yAxisDuration: 1.0)
                
            } catch {
                print("❌ Supabase error:", error)
            }
        }
    }
   
    func hygienePercent() {
        Task {
            do {
                // 1️⃣ Fetch hygiene ratings from Supabase
                let response = try await SupabaseManager.shared.client
                    .from("collectorFeedback")
                    .select("hygieneRate") // fetch the column with ratings
                    .execute()
                let val = response.data
                let decoded = try JSONDecoder().decode([hygineFeedback].self, from: val)
                
                // 3️⃣ Convert each rating to percentage (1–5 → 20–100%)
                let percentages = decoded.map { Double($0.hygieneRate) / 5.0 * 100.0 }
                
                // 4️⃣ Calculate average hygiene percent
                let avgPercent = percentages.isEmpty ? 0 : percentages.reduce(0, +) / Double(percentages.count)
                
                // 5️⃣ Update UI
                hygineRate.text = String(format: "%.0f%%", avgPercent)
                
            } catch {
                print("❌ Supabase error:", error)
            }
        }
    }
    func pickUpPercent() {
        Task {
            do {
                // 1️⃣ Fetch hygiene ratings from Supabase
                let response = try await SupabaseManager.shared.client
                    .from("DonerFeedback")
                    .select("pickupTime") // fetch the column with ratings
                    .execute()
                let val = response.data
                let decoded = try JSONDecoder().decode([pickUpTimeFeedback].self, from: val)
                
                // 3️⃣ Convert each rating to percentage (1–5 → 20–100%)
                let percentages = decoded.map { Double($0.pickupTime) / 5.0 * 100.0 }
                
                // 4️⃣ Calculate average hygiene percent
                let avgPercent = percentages.isEmpty ? 0 : percentages.reduce(0, +) / Double(percentages.count)
                
                // 5️⃣ Update UI
                pickUpTimeRate.text = String(format: "%.0f%%", avgPercent)
                
            } catch {
                print("❌ Supabase error:", error)
            }
        }
    }
    func PackagingPercent() {
        Task {
            do {
                // 1️⃣ Fetch hygiene ratings from Supabase
                let response = try await SupabaseManager.shared.client
                    .from("collectorFeedback")
                    .select("packagingRate") // fetch the column with ratings
                    .execute()
                let val = response.data
                let decoded = try JSONDecoder().decode([packagingFeedback].self, from: val)
                
                // 3️⃣ Convert each rating to percentage (1–5 → 20–100%)
                let percentages = decoded.map { Double($0.packagingRate) / 5.0 * 100.0 }
                
                // 4️⃣ Calculate average hygiene percent
                let avgPercent = percentages.isEmpty ? 0 : percentages.reduce(0, +) / Double(percentages.count)
                
                // 5️⃣ Update UI
                packagingRate.text = String(format: "%.0f%%", avgPercent)
                
            } catch {
                print("❌ Supabase error:", error)
            }
        }
    }
}
