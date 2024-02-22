//
//  ChoghadiyaView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/21/24.
//

import SwiftUI

struct ChoghadiyaView: View {
    @StateObject var viewModel = ChoghadiyaViewModel()
    @State var date = Date()
    
    var body: some View {
        NavigationStack {
            VStack{
                if (viewModel.choghadiya != nil) {
                    let choghadiya = viewModel.choghadiya
                    CustomDatePickerView(date: $date, timezone: viewModel.timezone)
                    List {
                        ForEach(choghadiya!.dayChoghadiya.gadiyas, id: \.1.upperBound) { gadiya in
                            HStack{
                                Text(gadiya.0)
                                Text(gadiya.1.lowerBound.toStringVersion())
                                Text(gadiya.1.upperBound.toStringVersion())
                            }
                        }
                        ForEach(choghadiya!.nightChoghadiya.gadiyas, id: \.1.lowerBound) { gadiya in
                            HStack{
                                Text(gadiya.0)
                                Text(gadiya.1.lowerBound.toStringVersion())
                                Text(gadiya.1.upperBound.toStringVersion())
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
                
            }.navigationTitle("Choghadiya")
            
        }
    }
}
