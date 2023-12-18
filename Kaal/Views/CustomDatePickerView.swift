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
                Button {
                    self.date = DateFormatter().calendar.date(byAdding: .day, value: -1, to: date) ?? date
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 30, height: 30)
                }
                
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
               
                
                Button {
                    self.date = DateFormatter().calendar.date(byAdding: .day, value: 1, to: date) ?? date
                } label: {
                    Image(systemName: "chevron.right")
                        .frame(width: 30, height: 30)
                }

            }
           
        }
    }
}

extension DatePickerStyle {
    
}

#Preview {
    CustomDatePickerView(date: .constant(Date()))
}
