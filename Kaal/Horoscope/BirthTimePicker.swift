//
//  BirthTimePicker.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/26/24.
//

import SwiftUI

struct BirthTimePicker: View {
    @Binding var showPicker: Bool
    @AppStorage("birthtime") var birthtime: String = ""
    @State var dateOfBirth: Date = Date()
    var optionalAction: (() -> Void)?
    var body: some View {
        VStack {
            Text("Select your time of birth")
                .padding()
            DatePicker("", selection: $dateOfBirth, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding(.bottom, 20)
            HStack{
                Button(action: {
                    showPicker = false
                    if let optionalAction = optionalAction {
                        optionalAction()
                    }
                }, label: {
                    Text("Cancel")
                })
                Spacer()
                Button(action: {
                    self.birthtime = formatDate(dateOfBirth)
                    showPicker = false
                    if let optionalAction = optionalAction {
                        optionalAction()
                    }
                }, label: {
                    Text("Save")
                })
            }.padding()
        }.overlay(content: {
            RoundedRectangle(cornerRadius: 4)
                .stroke(getTintColor(), lineWidth: 2)
        })
        .background(Color.white)
        .padding()
    }
    
    func formatDate(_ date: Date) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "hh:mm a"
         return dateFormatter.string(from: date)
     }
}

#Preview {
    BirthTimePicker(showPicker: .constant(true))
}
