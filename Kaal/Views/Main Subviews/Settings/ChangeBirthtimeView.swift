//
//  ChangeBirthtimeView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 7/9/24.
//

import SwiftUI

struct ChangeBirthtimeView: View {
    @State var birthtimeIsChanged = false
    @AppStorage("birthtime") var birthtime: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        BirthTimePicker(showPicker: .constant(true), optionalAction: {
            self.presentationMode.wrappedValue.dismiss()
        })
            .onChange(of: birthtime, { oldValue, newValue in
                birthtimeIsChanged.toggle()
            })
            .alert(isPresented: $birthtimeIsChanged) {
                Alert(
                    title: Text("Successful"),
                    message: Text("Birthtime changed to\n\(birthtime)"),
                    dismissButton: .default(Text("OK"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                )
            }
    }
}

#Preview {
    ChangeBirthtimeView()
}
