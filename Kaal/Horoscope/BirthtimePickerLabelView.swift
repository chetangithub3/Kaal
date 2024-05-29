//
//  BirthtimePickerLabelView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/27/24.
//

import SwiftUI

struct BirthtimePickerLabelView: View {
    @AppStorage("birthtime") var birthtime: String = ""
    @Binding var showBirthtimePicker: Bool
    var body: some View {
        Button {
            showBirthtimePicker = true
        } label: {
            HStack{
                VStack(alignment: .leading) {
                    HStack{
                        Image(systemName: "clock")
                        Text("Select your time of birth")
                        Spacer()
                    }
                    if !birthtime.isEmpty {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                           
                            Text(birthtime)
                                
                            Spacer()
                        }.foregroundColor(.black)
                    }
             
                    Text("Note: You can always change your time of birth from the settings.")
                        .noticeStyle()
                }
                Image(systemName: "arrow.right")
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(getTintColor(), lineWidth: 2)
            }
        }
    }
}

#Preview {
    BirthtimePickerLabelView(showBirthtimePicker: .constant(true))
}
