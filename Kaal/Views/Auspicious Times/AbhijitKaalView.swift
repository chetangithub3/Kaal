//
//  AbhijitKaalView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/10/23.
//

import SwiftUI

struct AbhijitKaalView: View {
    
    @EnvironmentObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack{
            KaalDetailView(kaalRange: viewModel.kaal.abhijitKaal)
        }
    }
    
}

#Preview {
    AbhijitKaalView()
}
