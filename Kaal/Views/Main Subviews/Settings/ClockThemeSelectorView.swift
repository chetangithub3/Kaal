//
//  ThemeSelectorView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/28/24.
//

import SwiftUI

struct ClockThemeSelectorView: View {
    @AppStorage("timeFormat") var storedTimeFormat: String = "hh:mm a"
    @State var selectedTimeFormat = ""
    var body: some View {
            HStack{
                Text("Clock format")
                Spacer()
                Picker("", selection: $selectedTimeFormat) {
                    Text("12 Hour").tag("hh:mm a")
                    Text("24 Hour").tag("HH:mm")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
            }
        .onAppear(perform: {
            selectedTimeFormat = storedTimeFormat
        })
        .onChange(of: selectedTimeFormat) { oldValue, newValue in
            self.storedTimeFormat = newValue
        }
    }
}

#Preview {
    ClockThemeSelectorView()
}
