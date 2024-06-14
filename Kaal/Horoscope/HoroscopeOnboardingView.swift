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
    @State private var gender: Gender = .male
    @AppStorage("genderSaved") var genderSaved: Gender?
    var body: some View {
        VStack {
            Text("Lets start with the essentials.")
                .font(.title3)
                .padding(.bottom, 20)
            Text("Name")
                .font(.title2)
                .bold()
                .padding(.bottom, 20)
            Text("What is your name?")
                .font(.title3)
            NameFieldsView(firstName: $firstName, middleName: $middleName, lastName: $lastName)
            GenderPickerView(selectedGender: $gender)
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
            self.name = "\(firstName.trimFirstAndLastSpaces()) \(middleName.trimFirstAndLastSpaces()) \(lastName.trimFirstAndLastSpaces())"
            self.genderSaved = gender
        }.navigationBarBackButtonHidden()
            .navigationTitle("Profile Setup")
            .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    HoroscopeOnboardingView()
}
