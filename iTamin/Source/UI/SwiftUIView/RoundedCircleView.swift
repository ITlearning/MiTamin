//
//  RoundedCircleView.swift
//  iTamin
//
//  Created by Tabber on 2022/09/29.
//

import SwiftUI

struct RoundedCircleView: View {
    
    var radius: CGFloat
    var width: CGFloat
    var height: CGFloat
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .frame(width: width, height: height)
            .foregroundColor(Color.white)
            .background(
                Color.black.opacity(0.1)
                .shadow(color: Color.black.opacity(0.1), radius: 0, x: 0, y: 8)
                .blur(radius: 20)
            )
    }
}
 
