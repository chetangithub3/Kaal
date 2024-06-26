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
            if ddViewModel.isLoading {
                HStack{
                    Spacer()
                    ProgressView("Searching")
                    Spacer()
                }.padding(.vertical)
            } else if $ddViewModel.results.count == 0{
                HStack{
                    Spacer()
                    Text("No results found. Please check the entry.")
                        
                    Spacer()
                }.padding(.vertical)
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
                    }
                }
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 2)
                .stroke(.primary.opacity(0.5), lineWidth: 1)
        }
        .padding()
      
        
    }
}

#Preview {
    DropDownMenuView(){_ in
        print("hello")
    }
}
