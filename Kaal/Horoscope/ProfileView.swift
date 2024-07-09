//
//  ProfileView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 6/14/24.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("birthplace") var birthplace: String = ""
    @AppStorage("birthday") var birthday: String = ""
    @AppStorage("name") var name = ""
    @AppStorage("genderSaved") var genderSaved: Gender?
    let dateFormatter = DateFormatter()
    var firstName: String {
        return name.components(separatedBy: " ").first ?? name
    }
    var age: Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy"
        guard let birthDate = dateFormatter.date(from: birthday) else {
            return nil
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: birthDate, to: Date())
        return components.year
    }
    
    var body: some View {
        VStack(alignment: .leading) {
           
            HStack(alignment: .center){
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(name)
                        .bold()
                    if let age = age {
                        Text(age.description)
                    }
                }
                Spacer()
                
                
            }.padding(.bottom)
            VStack(alignment: .leading) {
                HStack {
                    Text("Birthplace: ")
                    Text(birthplace)
                        .bold()
                }
                if let sunsign = getSunSign() {
                    HStack {
                        Text("Sun Sign: ")
                        Text(sunsign)
                            .bold()
                    }
                }
            }
        }.padding()
            .foregroundColor(getTintColor())
        .background(getTintColor().opacity(0.2))
            .cornerRadius(20)
            .padding([.horizontal, .bottom])
        
          
    }
    
    func getSunSign() -> String? {
        dateFormatter.dateFormat = "d MMMM, yyyy"
        guard let birthDate = dateFormatter.date(from: birthday) else {
            return nil
        }
        return SunSignClassifier.getSunSign(for: birthDate)
    }
    
    func getMoonSign() -> String? {
        dateFormatter.dateFormat = "d MMMM, yyyy"
        guard let birthDate = dateFormatter.date(from: birthday) else {
            return nil
        }
        return MoonSignClassifier.getMoonSign(for: birthDate)
    }
}

#Preview {
    ProfileView()
}
