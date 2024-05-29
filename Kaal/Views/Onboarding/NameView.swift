//
//  NameView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/28/24.
//

import SwiftUI

struct NameView: View {
    @State var fullName = ""
    @State private var firstName: String = ""
     @State private var middleName: String = ""
     @State private var lastName: String = ""
     @State private var go = false
     var body: some View {
         VStack(alignment: .leading) {
            NameFieldsView(firstName: $firstName, middleName: $middleName, lastName: $lastName)
             Spacer()
         if !(firstName.isEmpty || lastName.isEmpty){
             NavigationLink("", destination: LocationPermissionView(fullName: fullName), isActive: $go)
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
         .navigationTitle("Birth Name")
         .navigationBarTitleDisplayMode(.inline)
         .navigationBarBackButtonHidden()
        
     }
}

#Preview {
    NameView()
}
