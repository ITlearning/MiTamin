//
//  OnBoardingIndicator.swift
//  iTamin
//
//  Created by Tabber on 2022/11/06.
//

import SwiftUI

struct OnBoardingIndicator: View {
    
    var viewModel: SignUpViewModel
    @State var currentIdx: Int = 0
    var body: some View {
        HStack {
            ForEach(viewModel.descriptionArray.indices, id:\.self) { idx in
                circleView(idx: idx)
            }
        }
        .onReceive(viewModel.index, perform: { value in
            self.currentIdx = value
        })
    }
    
    func circleView(idx: Int) -> some View {
        ZStack {
            Circle()
                .strokeBorder(Color(uiColor: UIColor.primaryColor), lineWidth: 1)
                .frame(width: 12, height: 12)
            Circle()
                .foregroundColor(currentIdx >= idx ? Color(uiColor: UIColor.primaryColor) : Color.clear)
                .frame(width: 12, height: 12)
        }
    }
}
