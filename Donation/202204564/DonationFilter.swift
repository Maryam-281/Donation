//
//  DonationFilter.swift
//  Donation
//
//  Created by macOS on 22/12/2025.
//

import UIKit
import Foundation
import SwiftUI
import SwiftUICharts



class DonationFilter: UIViewController {
    
    // initialze radio buttons
    @IBOutlet weak var first10RadioButton: UIButton!
    @IBOutlet weak var otherRadioButton: UIButton!
    
    //initialize
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    @IBOutlet weak var chartContainerView: UIView!
    
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    // variables
    var hostingController: UIHostingController<DateRangeChartView>?
    //data for loading - donation data
    var allData: [ChartDataPoint] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call functions
        setupRadioButtons()
        loadSampleData()
        //updateChart()
    }
    
    
    // funation to unselect the radio buttons when loading
    func setupRadioButtons() {
        first10RadioButton.isSelected = false
        otherRadioButton.isSelected = false
    }
    
    // function to return the sender selection
    @IBAction func radioButtonTapped(_ sender: UIButton) {
        first10RadioButton.isSelected = false
        otherRadioButton.isSelected = false
        sender.isSelected = true
    }
    
    //Filter Button to update chart
    @IBAction func filterBtnClicked(_ sender: UIButton) {
        updateChart()
        sender.isSelected = true
    }
    
    @IBAction func resetBtnClicked(_ sender: UIButton) {
        loadSampleData()
        sender.isSelected = true
    }
    
    
    // chart and date picker
    struct ChartDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let value: Double
    }
    
    // load chart sample data
    func loadSampleData() {
        let calendar = Calendar.current
        
        for i in 0..<30 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let value = Double.random(in: 10...100)
            allData.append(ChartDataPoint(date: date, value: value))
        }
    }
    
    // change the chart according to dates
    
    @IBAction func dateRangeChanged(_ sender: UIDatePicker) {
        updateChart()
    }
    
    func updateChart() {
            let startDate = fromDatePicker.date
            let endDate = toDatePicker.date

            guard startDate <= endDate else { return }

            let filteredData = allData
                .filter { $0.date >= startDate && $0.date <= endDate }
                .sorted { $0.date < $1.date }

            let values = filteredData.map { $0.value }

            let chartView = DateRangeChartView(values: values)

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
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


