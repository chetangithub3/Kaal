//
//  BrahmaMuhurtaView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/11/23.
//

import SwiftUI

struct BrahmaMuhurtaView: View {
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State var date = Date()
    @EnvironmentObject var viewModel: DashboardViewModel
    @State var startTime = ""
    @State var endTime = ""
    var body: some View {
        VStack{
            KaalDetailView(kaalRange: viewModel.kaal.brahmaMahurat)
        }.navigationTitle(Kaal.brahma.rawValue)
            .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    BrahmaMuhurtaView()
}
