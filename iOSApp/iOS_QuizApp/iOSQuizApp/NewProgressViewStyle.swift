//
//  ProgressViewStyle.swift
//  iOSQuizApp
//
//  Created by Edwin Zhang on 4/19/23.
//

import SwiftUI

struct NewProgressView: View {
    var value: Float
    var height: CGFloat
    var tint: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .frame(height: height)
                    .foregroundColor(Color(.systemGray5))
                    
                RoundedRectangle(cornerRadius: height / 2)
                    .frame(width: CGFloat(value) * geometry.size.width, height: height)
                    .foregroundColor(tint)
            }
        }
        .frame(height: height) 
    }
}

struct NewProgressView_Previews: PreviewProvider {
    static var previews: some View {
        NewProgressView(value: 0.5, height: 10, tint: Color(hex: "#0077cc"))
            .previewLayout(.sizeThatFits)
    }
}
