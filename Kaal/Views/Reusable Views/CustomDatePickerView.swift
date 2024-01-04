//
//  CustomDatePickerView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/16/23.
//

import SwiftUI

struct CustomDatePickerView: View {
    @Binding var date: Date
    let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "EEEE, MMMM d, yyyy"
           return formatter
       }()
    
    var body: some View {
        
        VStack {
            HStack{
                Text("Date").font(.subheadline)
                Spacer()
                Button {
                    self.date = DateFormatter().calendar.date(byAdding: .day, value: -1, to: date) ?? date
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 30, height: 30)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.primary)
                        .background(Color.secondary)
                        .cornerRadius(10)
                }.disabled(self.date <= Date())
                    .opacity(self.date <= Date() ? 0.2  : 1.0)
                
                DatePicker("", selection: $date, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
               
                Button {
                    self.date = DateFormatter().calendar.date(byAdding: .day, value: 1, to: date) ?? date
                } label: {
                    Image(systemName: "chevron.right")
                        .frame(width: 30, height: 30)
                        .foregroundColor(.primary)
                        .background(Color.secondary)
                        .cornerRadius(10)
                }
            }
        }.padding(.horizontal)
    }
}

extension DatePickerStyle {
    
}

#Preview {
    CustomDatePickerView(date: .constant(Date()))
}
