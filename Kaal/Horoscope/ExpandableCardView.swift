//
//  ExpandableCardView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 6/10/24.
//

import SwiftUI

struct ExpandableCardView: View {
    let title: String
    let desc: String
    @State private var isExpanded = true
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }, label: {
                HStack{
                    Text(title)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .frame(width: 30, height: 30)
                        .foregroundColor(getTintColor())
                        .background(getTintColor().opacity(0.2))
                        .background(Color.white)
                        .cornerRadius(10)
                }
            })
            .padding()
            .background(Color.gray.opacity(0.3))
            if isExpanded{
                Text(desc)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            isExpanded = false
                        }
                       
                    }
            }
        }
        .background(.gray.opacity(0.2))
        .cornerRadius(20)
    }
}

#Preview {
    ExpandableCardView(title: "General", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
}
