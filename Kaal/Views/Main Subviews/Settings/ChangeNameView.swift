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
    @Environment(\.presentationMode) var presentationMode
    @State var nameIsChanged = false
    var body: some View {
        VStack {
            NameFieldsView(firstName: $firstName, middleName: $middleName, lastName: $lastName)
            Spacer()
            Button {
                self.name = getPolishedName()
                nameIsChanged = true
            } label: {
                Text("Save")
                    .longButtonStyle(isDisabled: firstName.isEmpty || lastName.isEmpty || name == getPolishedName())
            }.disabled(firstName.isEmpty || lastName.isEmpty || name == getPolishedName())
        }
        .padding()
        .navigationTitle("Change Name")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            assignNameSplit()
        })
        .alert(isPresented: $nameIsChanged) {
            Alert(
                title: Text("Successful"),
                message: Text("Name chnaged to\n\(getPolishedName())"),
                dismissButton: .default(Text("OK"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }
    func getPolishedName() -> String {
        "\(firstName.trimFirstAndLastSpaces()) \(middleName.trimFirstAndLastSpaces()) \(lastName.trimFirstAndLastSpaces())"
    }
    func assignNameSplit() {
        let words = name.split(separator: " ")
        if words.count == 3 {
            self.firstName = String(words[0])
            self.middleName = String(words[1])
            self.lastName = String(words[2])
        } else if words.count == 2 {
            self.firstName = String(words[0])
            self.lastName = String(words[1])
        } else {
            firstName = name
        }
    }
}

#Preview {
    ChangeNameView()
}
