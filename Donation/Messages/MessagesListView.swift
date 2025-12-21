//
//  SwiftUIView.swift
//  Donation
//
//  Created by BP-36-201-07 on 21/12/2025.
//

import SwiftUI

struct SwiftUIView: View {
   
    //PROPERTIES:
    
    var users: [user] = userData
    
    // BODY:
    
    var body: some View {
        NavigationView{
            List{
                ForEach(users) { item in
                    MessagesRowView(user:item)
                        .padding(.vertical, 4)
                }
            }
        }
    }
}
    
    // PREVIEW:

#Preview {
    SwiftUIView()
}
