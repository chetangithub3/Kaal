//
//  NoticeStyle.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/27/24.
//

import SwiftUI

struct NoticeStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .italic()
            .font(.subheadline)
            .foregroundColor(.gray)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
}

extension View {
    func noticeStyle() -> some View {
        self.modifier(NoticeStyle())
    }
}


struct LongButtonStyle: ViewModifier {
    var isDisabled: Bool
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDisabled ? getTintColor().opacity(0.5) : getTintColor())
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

extension View {
    func longButtonStyle(isDisabled: Bool = false) -> some View {
        self.modifier(LongButtonStyle(isDisabled: isDisabled))
    }
}

