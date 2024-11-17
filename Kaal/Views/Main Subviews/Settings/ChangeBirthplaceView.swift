//
//  ChangeBirthplaceView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 7/9/24.
//

import SwiftUI

struct ChangeBirthplaceView: View {
    @State var birthplaceIsChanged = false
    @AppStorage("birthplace") var birthplace: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            AddressSearchView(placeholder: birthplace.isEmpty ? nil : birthplace) { address in
                self.birthplace = address
            }
            .alert(isPresented: $birthplaceIsChanged) {
                Alert(
                    title: Text("Successful"),
                    message: Text("Birthplace is changed to\n\(birthplace)"),
                    dismissButton: .default(Text("OK"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                )
            }
            Spacer()
        }
        .onChange(of: birthplace) { oldValue, newValue in
            birthplaceIsChanged.toggle()
        }.navigationTitle("Change address")
    }
}

#Preview {
    ChangeBirthplaceView()
}
