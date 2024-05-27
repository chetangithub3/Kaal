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

