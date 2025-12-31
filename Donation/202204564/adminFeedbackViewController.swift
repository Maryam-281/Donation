//
//  adminFeedbackViewController.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import UIKit
import Foundation
import SwiftUI
import SwiftUICharts



class adminFeedbackViewController: UIViewController {

    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    
    override func viewDidLoad() {
        loadSampleData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func applybtnClicked(_ sender: UIButton) {
        updateChart()
        chartContainerView.isHidden = false
        sender.isSelected = true
    }
    
    @IBAction func clearBtnClicked(_ sender: UIButton) {
        chartContainerView.isHidden = true
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
        
    struct ChartDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let value: Double
    }
    
    var hostingController: UIHostingController<DateRangeChartView>?
    //data for loading - donation data
    var allData: [ChartDataPoint] = []
    
    func loadSampleData() {
        let calendar = Calendar.current
        
        for i in 0..<30 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let value = Double.random(in: 10...100)
            allData.append(ChartDataPoint(date: date, value: value))
        }
    }
    
    func updateChart() {
            let startDate = fromDatePicker.date
            let endDate = toDatePicker.date
        
            guard startDate <= endDate else { return }

            let filteredData = allData.filter { $0.date >= startDate && $0.date <= endDate } .sorted { $0.date < $1.date }

            let values = filteredData.map { $0.value }

            let chartView = DateRangeChartView(values: values, chartTitle: "Donations")

            if let hostingController = hostingController {
                
                hostingController.rootView = chartView
            } else {
                let hc = UIHostingController(rootView: chartView)
                addChild(hc)
                hc.view.frame = chartContainerView.bounds
                hc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                chartContainerView.addSubview(hc.view)
                hc.didMove(toParent: self)
                hostingController = hc
            }
        }
}
