//
//  HoroscopeOnboardingView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/26/24.
//

import SwiftUI

struct HoroscopeOnboardingView: View {
    @AppStorage("name") var name = ""
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Image("HoroscopeIcon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .symbolEffect(.variableColor.iterative)
                    .symbolVariant(.slash)
                Text("Unveil Your Destiny Today!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(getTintColor())
                    .padding(.vertical)
                Text("Unlock insights about your future based on your birthday, the time, and place of your birth.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                Spacer()
                if name.isEmpty {
                    NavigationLink {
                        Name()
                    } label: {
                        Text("Continue")
                            .longButtonStyle()
                    }
                } else {
                    NavigationLink {
                        AddDetailsView()
                    } label: {
                        Text("Continue")
                            .longButtonStyle()
                    }
                }
            }.padding()
        }
    }
}


struct Name: View {
    @AppStorage("name") var name = ""
    @State private var firstName: String = ""
     @State private var middleName: String = ""
     @State private var lastName: String = ""
    var body: some View {
        VStack {
            NameFieldsView(firstName: $firstName, middleName: $middleName, lastName: $lastName)
            Spacer()
            if !firstName.isEmpty && !lastName.isEmpty {
                NavigationLink {
                    AddDetailsView()
                } label: {
                    Text("Continue")
                        .longButtonStyle()
                }
            }
        }.padding()
        .onDisappear {
            self.name = "\(firstName) \(middleName) \(lastName)"
        }.navigationBarBackButtonHidden()
            .navigationTitle("Birth name")
            .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    HoroscopeOnboardingView()
}
