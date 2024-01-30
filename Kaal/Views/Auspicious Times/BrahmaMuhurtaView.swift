//
//  BrahmaMuhurtaView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/11/23.
//

import SwiftUI

struct BrahmaMuhurtaView: View {
    
    @EnvironmentObject var viewModel: DashboardViewModel
    @Binding var date: Date
    
    var body: some View {
        VStack{
            KaalDetailView(kaalRange: viewModel.kaal.brahmaMahurat, kaal: Kaal.brahma, date: $date)
        }.navigationTitle(Kaal.brahma.title)
            .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    BrahmaMuhurtaView(date: .constant(Date()))
}
