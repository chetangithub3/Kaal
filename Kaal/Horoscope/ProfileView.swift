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
        HStack {
            VStack {
                Text(name)
               Text(birthplace)
            }
            Spacer()
            VStack {
                if let sunsign = getSunSign(), let moonsign = getMoonSign(){
                    if let age = age {
                        Text(age.description)
                    }
                    Text("Sun Sign - \(sunsign)")
                    
                }
            }
        }.background(getTintColor().opacity(0.3))
            .cornerRadius(20)
            .padding(.horizontal)
          
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
