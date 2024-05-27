//
//  BirthTimePicker.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/26/24.
//

import SwiftUI

struct BirthTimePicker: View {
    @Binding var showPicker: Bool
    @AppStorage("birthday") var birthday: String = ""
    @State var dateOfBirth: Date = Date()
    
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
                }, label: {
                    Text("Cancel")
                })
                Spacer()
                Button(action: {
                    self.birthday = formatDate(dateOfBirth)
                    showPicker = false
                }, label: {
                    Text("Save")
                })
            }.padding()
        }.overlay(content: {
            RoundedRectangle(cornerRadius: 4)
                .stroke(getTintColor(), lineWidth: 2)
        })
        .padding()
        .background(Color.white)
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
