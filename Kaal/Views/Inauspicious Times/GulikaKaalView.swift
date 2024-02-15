//
//  GulikaKaalView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/14/24.
//

import SwiftUI

struct GulikaKaalView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @Binding var date: Date
    var body: some View {
        VStack{
            KaalDetailView(kaalRange: viewModel.kaal.gulikaKaal, kaal: Kaal.gulika, date: $date)
        }.navigationTitle(Kaal.gulika.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GulikaKaalView(date: .constant(Date()))
}
