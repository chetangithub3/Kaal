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
        VStack{
            if ddViewModel.results.count == 0 {
                Text("No results found")
            } else {
                ScrollView{
                    VStack(alignment: .center, spacing: 16){
                        ForEach($ddViewModel.results.indices) { option in
                            VStack(spacing: 0){
                                HStack(alignment: .center) {
                                    Text(ddViewModel.results[option].displayName ?? "")
                                        .multilineTextAlignment(.leading)
                                        
                                    Spacer()
                                }
                                Divider().padding(.horizontal)
                            }.padding(.horizontal)
                                .onTapGesture(perform: {
                                    action(option)
                                })
                                
                           
                               
                        }
                    }
                }
                    .overlay {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(.primary.opacity(0.5), lineWidth: 2)
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
