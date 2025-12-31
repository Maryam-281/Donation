//
//  adminDonationsViewController.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import UIKit
import Foundation
import SwiftUI
import SwiftUICharts



class adminDonationsViewController: UIViewController {
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var filterButten: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    var hostingController: UIHostingController<DateRangeChartView>?
    
    var allData: [ChartDataPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadSampleData()
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
    
    
    @IBAction func filterbtnClicked(_ sender: UIButton) {
        updateChart()
        chartContainerView.isHidden = false
        sender.isSelected = true
    }
    
    @IBAction func resetBtnClicked(_ sender: UIButton) {
        chartContainerView.isHidden = true
        fromDatePicker.setDate(Date(), animated: true)
        toDatePicker.setDate(Date(), animated: true)
        sender.isSelected = true
    }
    
    struct ChartDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let value: Double
    }
    
    func loadSampleData() {
        let calender  = Calendar.current
        
        for i in 0..<30 {
            let date = calender.date(byAdding: .day, value: -i, to: Date())!
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
