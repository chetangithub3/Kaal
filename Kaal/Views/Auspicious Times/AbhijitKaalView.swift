//
//  AbhijitKaalView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/10/23.
//

import SwiftUI

struct AbhijitKaalView: View {
    
    @EnvironmentObject var viewModel: DashboardViewModel
    @Binding var date: Date
    var body: some View {
        VStack{
            KaalDetailView(kaalRange: viewModel.kaal.abhijitKaal, kaal: Kaal.abhijit, date: $date)
        }.navigationTitle(Kaal.abhijit.title)
            .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    AbhijitKaalView(date: .constant(Date()))
}
