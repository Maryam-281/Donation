//
//  DonationHistoryListView.swift
//  Donation
//
//  Created by BP-36-201-07 on 21/12/2025.
//

import SwiftUI


struct DonationHistoryListView: View {
    
    var donations: [Donation] = donationData
    
    var body: some View {
        NavigationView{
            List{
                ForEach(donation) { item in
                    MessagesRowView(donation:item)
                        .padding(.vertical, 4)
                }
            }
    }
}

#Preview {
    DonationHistoryListView()
}
