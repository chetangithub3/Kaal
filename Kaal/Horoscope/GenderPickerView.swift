//
//  GenderPickerView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 6/5/24.
//

import SwiftUI


struct GenderPickerView: View {
    @Binding var selectedGender: Gender
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                Text("Please select your gender:")
                    .font(.title3)
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                Spacer()
                Picker("Select your gender", selection: $selectedGender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue).tag(gender)
                            .foregroundColor(.black)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                .background(getTintColor().opacity(0.2))
                .cornerRadius(20)
            }
        }
    }
}


#Preview {
    GenderPickerView(selectedGender: .constant(.male))
}
