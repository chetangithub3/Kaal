//
//  BirthdayPicker.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/26/24.
//

import SwiftUI

struct BirthdayPicker: View {
    
    @Binding var showPicker: Bool
    @AppStorage("birthday") var birthday: String = ""
    @State var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -4, to: Date())!
    var optionalAction: (() -> Void)?
    var body: some View {
        VStack{
            Text("Select your date of birth")
                .padding()
            DatePicker("", selection: $dateOfBirth, in: ...Date(), displayedComponents: .date)
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
                    self.birthday = formatBirthDate(dateOfBirth)
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
    
    func formatBirthDate(_ date: Date) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "d MMMM, yyyy"
         return dateFormatter.string(from: date)
     }
}
