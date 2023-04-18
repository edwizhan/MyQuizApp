//
//  RingView.swift
//  
//
//  Created by Edwin Zhang.
//

import SwiftUI

struct RingView: View {
    var scorePercentage: Double
    var lineWidth: CGFloat
    var color: Color
    var animateProgress: Bool

    var progress: CGFloat {
        CGFloat(scorePercentage / 100)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: animateProgress ? progress : 0)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0), value: animateProgress)
        }
    }
}
