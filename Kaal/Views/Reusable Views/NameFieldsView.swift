//
//  NameFieldsView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/28/24.
//

import SwiftUI

struct NameFieldsView: View {
    @Binding var firstName: String
     @Binding  var middleName: String
     @Binding  var lastName: String
    var body: some View {
        VStack {
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
        }
    }
}


