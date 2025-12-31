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
    var chartTitle: String?

    var body: some View {
        LineChartUIView(
            values: values,
            chartTitle: chartTitle
        )
        .frame(width: 350, height: 250)
        .padding()
        // .clipShape(RoundedRectangle(cornerRadius: 12))
        // .overlay(
        //     RoundedRectangle(cornerRadius: 12)
        //         .stroke(Color.gray, lineWidth: 1)
        // )
    }
}

