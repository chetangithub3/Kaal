//
//  BirthplacePicker.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/27/24.
//

import SwiftUI

struct BirthplacePicker: View {
    @Binding var showPicker: Bool
    @AppStorage("birthplace") var birthplace: String = ""
    var body: some View {
        VStack{
            Text("Enter your birthplace")
                .padding(.top)
          
            AddressSearchView(placeholder: birthplace.isEmpty ? nil : birthplace) { address in
                self.birthplace = address
                showPicker = false
            }
                Button(action: {
                    showPicker = false
                }, label: {
                    Text("Cancel")
                })
            .padding()
        }.overlay(content: {
            RoundedRectangle(cornerRadius: 4)
                .stroke(getTintColor(), lineWidth: 2)
        })
        .background(Color.white)
        .padding()
    }
}

#Preview {
    BirthplacePicker(showPicker: .constant(true))
}
