//
//  SettingsMenuView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/12/23.
//

import SwiftUI



struct SettingsMenuView: View {
    @AppStorage("timeFormat") var storedTimeFormat: String = "hh:mm a"
    @State var selectedTimeFormat = ""
    var body: some View {
        Form {
            Section("Clock") {
                
                HStack{
                    Text("Time format")
                    Spacer()
                    Picker("", selection: $selectedTimeFormat) {
                        Text("12 Hour").tag("hh:mm a")
                        Text("24 Hour").tag("HH:mm")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                }
                
            }

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
    SettingsMenuView()
}
