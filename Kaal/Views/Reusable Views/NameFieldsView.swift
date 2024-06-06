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
        VStack(alignment: .leading) {
            Text("Lets start with the essentials.")
                .font(.title3)
                .padding(.bottom, 20)
            Text("Name")
                .font(.title2)
                .bold()
                .padding(.bottom, 20)
            Text("What is your name?")
                .font(.title3)
            HStack{
                TextField("First Name *", text: $firstName)
                    .padding()
                    .background(getTintColor().opacity(0.2))
                    .cornerRadius(20)
                TextField("Last Name *", text: $lastName)
                    .padding()
                    .background(getTintColor().opacity(0.2))
                    .cornerRadius(20)
            }
            TextField("Middle Name (optional)", text: $middleName)
                .padding()
                .background(getTintColor().opacity(0.2))
                .cornerRadius(20)
        }
    }
}
