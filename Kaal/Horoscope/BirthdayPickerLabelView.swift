//
//  BirthdayPickerLabelView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/27/24.
//

import SwiftUI

struct BirthdayPickerLabelView: View {
    @AppStorage("birthday") var birthday: String = ""
    @Binding var showBirthdayPicker: Bool
    var body: some View {
        Button {
            showBirthdayPicker = true
        } label: {
            HStack{
                VStack {
                    HStack{
                        Image(systemName: "calendar")
                        Text("Select your date of birth")
                        Text("*")
                            .foregroundColor(.red)
                        Spacer()
                    }
                    if !birthday.isEmpty {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            
                            Text(birthday)
                                
                            Spacer()
                        }.foregroundColor(.black)
                    }
                }
                Image(systemName: "arrow.right")
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(getTintColor(), lineWidth: 2)
            }
            .padding(.top)
        }
    }
}

#Preview {
    BirthdayPickerLabelView(showBirthdayPicker: .constant(true))
}
