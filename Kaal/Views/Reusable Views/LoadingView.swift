    //
    //  LoadingView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/16/23.
    //

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            Image("loadingIcon") // Replace with your image
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(15)
                .rotationEffect(.degrees(isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 3.0).repeatForever(autoreverses: false))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        self.isLoading = true
                    }
                }
        }
    }
}

#Preview {
    LoadingView()
}
