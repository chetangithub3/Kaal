    //
    //  DropDownMenuView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 1/20/24.
    //

import SwiftUI

struct DropDownMenuView: View {
    @EnvironmentObject var ddViewModel: AddressSearchViewModel
    var action: (Int) -> Void
    var body: some View {
        VStack(spacing: 0){
            if ddViewModel.results.count == 0 {
                Text("No results found")
            } else {
                ScrollView{
                    VStack{
                        ForEach($ddViewModel.results.indices) { option in
                            VStack(spacing: 0){
                                HStack(alignment: .center) {
                                    Text(ddViewModel.results[option].displayName ?? "")
                                        .multilineTextAlignment(.leading)
                                        
                                    Spacer()
                                }.padding(8)
                                Divider().padding(.horizontal, 8)
                            }
                            
                                .onTapGesture(perform: {
                                    action(option)
                                })
                        }
                    } .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.primary.opacity(0.5), lineWidth: 2)
                    }
                }
            }
            
        }.padding()
        
    }
}

#Preview {
    DropDownMenuView(){_ in
        print("hello")
    }
}
