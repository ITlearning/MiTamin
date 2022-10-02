//
//  LineProgressBar.swift
//  iTamin
//
//  Created by Tabber on 2022/10/02.
//

import SwiftUI

struct LineProgressBar: View {
    
    //@StateObject var viewModel
    @State var progress: Double = 0.8
    @State var nextProgress: Double = 0.0
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * progress, height: 5)
                .foregroundColor(Color(uiColor: UIColor.grayColor3))
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                if nextProgress != 0.0 {
                    withAnimation {
                        progress = nextProgress
                    }
                }
            })
        }
    }
}
