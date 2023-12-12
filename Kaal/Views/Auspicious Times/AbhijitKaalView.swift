//
//  AbhijitKaalView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/10/23.
//

import SwiftUI

struct AbhijitKaalView: View {
    
    
    @State var date = Date()
    @EnvironmentObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack{
            DatePicker("Change Date", selection: $date, displayedComponents: .date)
            
            Text("Start time: \(viewModel.kaal.abhijitKaal.lowerBound)")
            Text("End time: \(viewModel.kaal.abhijitKaal.upperBound)")
        }
        .onChange(of: date) { oldValue, newValue in
           viewModel.daylightFromLocation(on: date)
        }
    }
}

#Preview {
    AbhijitKaalView()
}
