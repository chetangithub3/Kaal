//
//  AddDetailsView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/26/24.
//

import SwiftUI

struct AddDetailsView2: View {
    @AppStorage("horoscopeObDone") var horoscopeObDone: Bool = false
    @AppStorage("birthArea") var birthArea: String = ""
    @AppStorage("birthday") var birthday: String = ""
    @State private var placeOfBirth: String = ""
    @State private var dateOfBirth: Date = Date()
    @State var showBirthdayPicker = false
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Text("Your horoscope is based on many factors including your birthday, the time, and place of your birth.")
                    .font(.title3)
                    .multilineTextAlignment(.leading)
               
            


                NavigationLink {
                    VStack{
                        Button(action: {
                            showBirthdayPicker = true
                        }, label: {
                            HStack{
                                Image(systemName: "calendar")
                                Text("Select your date of birth")
                            }
                            
                        })
                        if !self.birthday.isEmpty {
                            Text(birthday)
                        }
                    }.overlay {
                        if showBirthdayPicker {
                            ZStack{
                                Color.white.opacity(0.8)
                                BirthdayPicker(showPicker: $showBirthdayPicker)
                            }
                            
                        }
                    }
                } label: {
                    VStack{
                        HStack{
                            Image(systemName: "calendar")
                            Text("Select your date of birth")
                        }
                        Spacer()
                        HStack{
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                    }
                   
                }

                
               
                
                Text("Place of Birth")
                    .font(.headline)
                
                AddressSearchView { address in
                    self.birthArea = address
                }
                if !self.birthArea.isEmpty {
                    Text(birthArea)
                }
                Spacer()
                
            }
            .padding(.horizontal, 30)
            if !self.birthday.isEmpty && !self.birthArea.isEmpty{
                Button(action: {
                    horoscopeObDone = true
                }, label: {
                    Text("Finish")
                })
            }
        }
//        .navigationBarHidden(true)
    }
}

struct AddDetailsView: View {
    @AppStorage("horoscopeObDone") var horoscopeObDone: Bool = false
    @AppStorage("birthArea") var birthArea: String = ""
    @AppStorage("birthday") var birthday: String = ""
    @AppStorage("birthtime") var birthtime: String = ""
    @State private var placeOfBirth: String = ""
    @State private var dateOfBirth: Date = Date()
    @State var showBirthdayPicker = false
    @State var showBirthtimePicker = false
    var body: some View {
        VStack {
            Text("Your horoscope is based on many factors including your birthday, the time, and place of your birth.")
                .font(.title3)
                .multilineTextAlignment(.leading)
            BirthdayPickerLabelView(showBirthdayPicker: $showBirthdayPicker)
            BirthtimePickerLabelView(showBirthtimePicker: $showBirthtimePicker)
            
            Spacer()
        }.padding()
        .blur(radius: showBirthdayPicker || showBirthtimePicker ? 10 : 0)
        .overlay {
            if showBirthdayPicker {
                BirthdayPicker(showPicker: $showBirthdayPicker)
            }
            if showBirthtimePicker {
                BirthTimePicker(showPicker: $showBirthtimePicker)
            }
        }
        .navigationBarHidden(true)
        
    }
}




#Preview {
    AddDetailsView()
}
