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
    @State var height: CGFloat = 30
    
    var body: some View {
        
        VStack {
            HStack{
                Text("Date").font(.subheadline)
                Spacer()
                Button {
                    self.date = DateFormatter().calendar.date(byAdding: .day, value: -1, to: date) ?? date
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: height, height: height)
                        .foregroundColor(.primary)
                        .background(Color.secondary)
                        .cornerRadius(10)
                }.disabled(self.date <= Date())
                    .opacity(self.date <= Date() ? 0.0  : 1.0)
         
                    DatePicker("", selection: $date, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .background(
                            GeometryReader { geometry in
                                Rectangle()
                                    .opacity(0.0)
                                    .onAppear {
                                        self.height = geometry.size.height
                                    }
                            }
                        )
                       
                
          
               
                Button {
                    self.date = DateFormatter().calendar.date(byAdding: .day, value: 1, to: date) ?? date
                } label: {
                    Image(systemName: "chevron.right")
                        .frame(width: height, height: height)
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
