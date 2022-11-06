//
//  ProgressBar.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var currentPoint: CGFloat
    private let maxPoint: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometyReader in
            ZStack(alignment: .leading) {
                Rectangle()
                    .opacity(0.1)
                Rectangle()
                    .frame(minWidth: 0, idealWidth:self.getProgressBarWidth(geometry: geometyReader),
                           maxWidth: 4)
                    .opacity(0.5)
                    .background(Color(hex: 0xD9D9D9))
                    .animation(.default)
            }
        }
    }
    
    func getProgressBarWidth(geometry:GeometryProxy) -> CGFloat {
        let frame = geometry.frame(in: .global)
        return frame.size.width * currentPoint
    }
}
