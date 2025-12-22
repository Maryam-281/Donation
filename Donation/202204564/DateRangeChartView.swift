//
//  DateRangeChartView.swift
//  Donation
//
//  Created by macOS on 22/12/2025.
//

import SwiftUI
import SwiftUICharts

struct DateRangeChartView: View {

    var values: [Double]

    var body: some View {
        LineChartView(
            data: values,
            title: "Donation Chart",
            legend: "Values"
        )
        .padding()
    }
}

