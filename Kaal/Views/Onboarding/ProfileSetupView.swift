//
//  NameView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/28/24.
//

import SwiftUI

struct ProfileSetupView: View {
    @State var fullName = ""
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    @State private var go = false
    @State private var gender: Gender = .male
    var body: some View {
        VStack(alignment: .leading) {
            Text("Lets start with the essentials.")
                .font(.title3)
                .padding(.bottom, 20)
            Text("Name")
                .font(.title2)
                .bold()
            NameFieldsView(firstName: $firstName, middleName: $middleName, lastName: $lastName)
                .padding(.bottom)
            Text("Gender")
                .font(.title2)
                .bold()
            GenderPickerView(selectedGender: $gender)
            Spacer()
            if !(firstName.isEmpty || lastName.isEmpty){
                NavigationLink("", destination: LocationPermissionView(fullName: fullName, gender: gender), isActive: $go)
                Button {
                    self.fullName = "\(firstName) \(middleName) \(lastName)"
                    go = true
                } label: {
                    Text("Next")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(firstName.isEmpty ? Color.gray : getTintColor())
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle("Profile Setup")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        
     }
}

#Preview {
    ProfileSetupView()
}
