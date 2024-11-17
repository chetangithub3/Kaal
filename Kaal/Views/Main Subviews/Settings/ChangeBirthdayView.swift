//
//  ChangeBirthdayView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 7/9/24.
//

import SwiftUI

struct ChangeBirthdayView: View {
    @State var ageIsChanged = false
    @AppStorage("birthday") var birthday: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        BirthdayPicker(showPicker: .constant(true)) {
            presentationMode.wrappedValue.dismiss()
        }
        .onChange(of: birthday, { oldValue, newValue in
            ageIsChanged.toggle()
        })
        .alert(isPresented: $ageIsChanged) {
            Alert(
                title: Text("Successful"),
                message: Text("Birthday changed to\n\(birthday)"),
                dismissButton: .default(Text("OK"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }
}

#Preview {
    ChangeBirthdayView()
}
