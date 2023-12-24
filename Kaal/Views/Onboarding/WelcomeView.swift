    //
    //  WelcomeView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/23/23.
    //

import SwiftUI

struct WelcomeView: View {
    @AppStorage("isFirstTime") var isFirstTime = true
    var body: some View {
        NavigationView{
            VStack{
                Image("yantra-svg")
                    .resizable()
                    .frame(width: .infinity)
                    .padding()
                
                
                
                    .frame(height: getScreenBounds().width)
                    .background(Color.gray.opacity(0.2).gradient)
                
                VStack{
                    Text("Kaal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Your celestial guide to finding the right moments.")
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                }
                .padding()
                Spacer()
               
                NavigationLink(destination: LocationPermissionView().environmentObject(AddressSearchViewModel(apiManager: APIManager()))) {
                    Text("Next")
                }
            }.frame(alignment: .top)
            
        }
        .ignoresSafeArea()
        .toolbar(.hidden)
    }
}

#Preview {
    WelcomeView()
}
