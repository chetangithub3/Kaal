//
//  RahuKaalView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/12/23.
//

import SwiftUI

struct RahuKaalView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @Binding var date: Date
    var body: some View {
        VStack{
            KaalDetailView(kaalRange: viewModel.kaal.rahuKaal, kaal: Kaal.rahu, date: $date)
        }.navigationTitle(Kaal.rahu.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    RahuKaalView(date: .constant(Date()))
}
