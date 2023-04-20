//
//  ProgressViewStyle.swift
//  iOSQuizApp
//
//  Created by Edwin Zhang on 4/19/23.
//

import SwiftUI

struct NewProgressViewStyle: ProgressViewStyle {
    var height: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .scaleEffect(x: 1, y: height, anchor: .center)
    }
}

struct NewProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        NewProgressViewStyle()
    }
}
