//
//  ChangeNameView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 6/7/24.
//

import SwiftUI

struct ChangeNameView: View {
    @AppStorage("name") var name = ""
    @State private var firstName: String = ""
     @State private var middleName: String = ""
     @State private var lastName: String = ""
    @AppStorage("genderSaved") var genderSaved: Gender?
    var body: some View {
        VStack {
            NameFieldsView(firstName: $firstName, middleName: $middleName, lastName: $lastName)
            Spacer()
            Button {
                self.name = "\(firstName) \(middleName) \(lastName)"
            } label: {
                Text("Save")
                    .longButtonStyle()
            }
        }.padding()
            .navigationTitle("Change Name")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChangeNameView()
}
