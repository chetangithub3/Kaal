//
//  BirthplacePickerLabelView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/27/24.
//

import SwiftUI

struct BirthplacePickerLabelView: View {
    @AppStorage("birthplace") var birthplace: String = ""
    @Binding var showBirthtimePicker: Bool
    var body: some View {
        Button {
            showBirthtimePicker = true
        } label: {
            HStack{
                VStack(alignment: .leading) {
                    HStack{
                        Image(systemName: "mappin.circle")
                        Text("Select your place of birth")
                        Text("*")
                            .foregroundColor(.red)
                        Spacer()
                    }
                    if !birthplace.isEmpty {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                           
                            Text(birthplace)
                                
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
        }.padding(.top)
    }
}

#Preview {
    BirthplacePickerLabelView(showBirthtimePicker: .constant(true))
}
