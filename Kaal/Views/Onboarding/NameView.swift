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
             Text("Lets start with the essentials. What is your name?")
                 .font(.title2)
                 .padding(.bottom, 20)
             HStack{
                 TextField("First Name *", text: $firstName)
                     .padding()
                     .background(getTintColor().opacity(0.2))
                     .cornerRadius(8)
                 TextField("Last Name *", text: $lastName)
                     .padding()
                     .background(getTintColor().opacity(0.2))
                     .cornerRadius(8)
             }
             TextField("Middle Name (optional)", text: $middleName)
                 .padding()
                 .background(getTintColor().opacity(0.2))
                 .cornerRadius(8)
             
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
        
     }
}

#Preview {
    NameView()
}
