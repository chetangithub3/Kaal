//
//  NeutralTimesGridView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/9/23.
//

import SwiftUI

struct OthersGridView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())]) {
          
               
            }
            
        }.padding()
    }
}

#Preview {
    OthersGridView()
}
