//
//  CompactDatePickerView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 1/29/24.
//

import Foundation
import SwiftUI

struct CompactDatePickerView: View {
        // to dismiss the calender view on change of date - workaround
    @Binding var date: Date
    @State private var calendarId = UUID()
    var body: some View {
        DatePicker("", selection: $date, in: Date()..., displayedComponents: [.date])
            .datePickerStyle(CompactDatePickerStyle())
            .labelsHidden()
            .id(calendarId)
            .onChange(of: date) { oldValue, newValue in
                // to dismiss the calender view
                calendarId = UUID()
            }
    }
}
