//
//  YamaGandaView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/12/23.
//

import SwiftUI

struct YamaGandaView: View {
    
    @EnvironmentObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack{
            KaalDetailView(kaalRange: viewModel.kaal.yamaKaal)
        }
       
    }
   
}

#Preview {
    YamaGandaView()
}
