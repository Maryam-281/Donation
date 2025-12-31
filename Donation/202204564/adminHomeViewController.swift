//
//  adminHomeViewController.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import UIKit
import Foundation
import SwiftUI
import SwiftUICharts


class adminHomeViewController: UIViewController {
    @IBOutlet weak var donationView: UIView!
    @IBOutlet weak var donationSuportView: UIView!
    @IBOutlet weak var donationMonthlyChartBorderView: UIView!
    @IBOutlet weak var donationYearlyChartBorderView: UIView!
    @IBOutlet weak var monthlyDonationChart: UIView!
    @IBOutlet weak var yearDonationChart: UIView!
    
    private var monthlyHostingController: UIHostingController<DateRangeChartView>?
    private var yearlyHostingController: UIHostingController<DateRangeChartView>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donationView.layer.borderColor = UIColor.lightGray.cgColor
        donationSuportView.layer.borderColor = UIColor.lightGray.cgColor
        donationMonthlyChartBorderView.layer.borderColor = UIColor.lightGray.cgColor
        donationYearlyChartBorderView.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
        monthlyChart()
        yearlyChart()
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

    func monthlyChart() {
        let values = [1.1, 2.2, 3.3]
        let chartView = DateRangeChartView(values: values, chartTitle: nil)
        
        if let hc = monthlyHostingController {
            hc.rootView = chartView
        } else {
            let hc = UIHostingController(rootView: chartView)
            addChild(hc)
            hc.view.frame = monthlyDonationChart.bounds
            hc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            monthlyDonationChart.addSubview(hc.view)
            hc.didMove(toParent: self)
            monthlyHostingController = hc
        }
    }
    
    func yearlyChart() {
        let values = [6.1, 5.2, 4.3]
        let chartView = DateRangeChartView(values: values, chartTitle: nil)

        if let hc = yearlyHostingController {
            hc.rootView = chartView
        } else {
            let hc = UIHostingController(rootView: chartView)
            addChild(hc)
            hc.view.frame = yearDonationChart.bounds
            hc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            yearDonationChart.addSubview(hc.view)
            hc.didMove(toParent: self)
            yearlyHostingController = hc
        }
    }
}
