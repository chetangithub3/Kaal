//
//  AddDetailsView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/26/24.
//

import SwiftUI

struct AddDetailsView: View {
    @AppStorage("horoscopeObDone") var horoscopeObDone: Bool = false
    @AppStorage("birthplace") var birthplace: String = ""
    @AppStorage("birthday") var birthday: String = ""
    @AppStorage("birthtime") var birthtime: String = ""
    @State private var placeOfBirth: String = ""
    @State private var dateOfBirth: Date = Date()
    @State var showBirthdayPicker = false
    @State var showBirthtimePicker = false
    @State var showBirthplacePicker = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your horoscope is based on many factors including your birthday, the time, and place of your birth.")
                .font(.title3)
                .multilineTextAlignment(.leading)
            
            BirthdayPickerLabelView(showBirthdayPicker: $showBirthdayPicker)
                .padding(.vertical)
            BirthplacePickerLabelView(showBirthtimePicker: $showBirthplacePicker)
                .padding(.bottom)
            VStack(alignment: .leading, spacing: 4) {
                Text("Optional:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Divider()
            }
            BirthtimePickerLabelView(showBirthtimePicker: $showBirthtimePicker)
           
            
            Spacer()
            if !self.birthday.isEmpty && !self.birthplace.isEmpty {
                Button {
                    horoscopeObDone = true
                } label: {
                    Text("Finish")
                        .longButtonStyle()
                }
            }

        }.padding()
        .blur(radius: showBirthdayPicker || showBirthtimePicker || showBirthplacePicker ? 10 : 0)
        .overlay {
            if showBirthdayPicker {
                withAnimation {
                    BirthdayPicker(showPicker: $showBirthdayPicker)
                }
            }
            if showBirthtimePicker {
                withAnimation {
                    BirthTimePicker(showPicker: $showBirthtimePicker)
                }
            }
            if showBirthplacePicker {
                withAnimation {
                    BirthplacePicker(showPicker: $showBirthplacePicker)
                }
            }
        }
        .navigationTitle("Horoscope")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    AddDetailsView()
}
