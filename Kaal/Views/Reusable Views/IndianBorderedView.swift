//
//  IndianBorderedView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 4/2/24.
//

import SwiftUI

#Preview {
    Border()
}


struct Border: View {
    let radius: CGFloat = 10
        let pi = Double.pi
        let dotCount = 10
        let dotLength: CGFloat = 3
        let spaceLength: CGFloat = 50
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.yellow, lineWidth: 10)
            .stroke(Color.red, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [dotLength, spaceLength], dashPhase: 0))
            .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [dotLength, spaceLength], dashPhase: 15))
            .stroke(Color.green, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [dotLength, spaceLength], dashPhase: 30))
            
       
            
    }
}
