//
//  ProgressBar.swift
//  Tomate
//
//  Created by Fabian Kropfhamer on 17.02.22.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Double
    var lineWidth = 35.0
    var color = Color.green

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.6)
                .foregroundColor(color)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: progress)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    @State static var progress = 0.95
    
    static var previews: some View {
        ProgressBar(progress: $progress).frame(width: 300, height: 300)
    }
}
