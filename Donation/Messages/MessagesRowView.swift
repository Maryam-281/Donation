//
//  MessagesRowView.swift
//  Donation
//
//  Created by BP-36-201-07 on 21/12/2025.
//

import SwiftUI

struct MessagesRowView: View {
    
    //PROPERTIES:
    
    var user:Username
    
    // BODY:
    var body: some View {
        HStack{
            Image(user.image)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width:80, height:80, alignment: .center)
        }
        VStack(alignment: .leading, spacing: 5){
            Text(user.title)
                .font(.title2)
                .fontWeight(.bold)
            Text(user.headline)
                .font(.caption)
                .foregroundColor(Color.secondary)
        }
    }
}
    //PREVIEW:
#Preview {
    MessagesRowView()
}
