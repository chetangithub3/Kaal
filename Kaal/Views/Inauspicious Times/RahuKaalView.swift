//
//  RahuKaalView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/12/23.
//

import SwiftUI

struct RahuKaalView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack{
            KaalDetailView(kaalRange: viewModel.kaal.rahuKaal)
        }.navigationTitle(Kaal.rahu.rawValue)
            .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    RahuKaalView()
}
