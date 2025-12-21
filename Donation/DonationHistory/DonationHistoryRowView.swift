//
//  DonationHistoryRowView.swift
//  Donation
//
//  Created by BP-36-201-07 on 21/12/2025.
//

import SwiftUI

struct DonationHistoryRowView: View {
    
    var donation:DHistory
    
    var body: some View {
        HStack{
            Image(donation.image)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width:80, height:80, alignment: .center)
        }
        VStack(alignment: .leading, spacing: 5){
            Text(donation.title)
                .font(.title2)
                .fontWeight(.bold)
            Text(donation.headline)
                .font(.caption)
                .foregroundColor(Color.secondary)
        }
    }
}

#Preview {
    DonationHistoryRowView()
}
