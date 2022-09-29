//
//  IndicatorView.swift
//  iTamin
//
//  Created by Tabber on 2022/09/29.
//

import SwiftUI

struct IndicatorView: View {
    
    @StateObject var viewModel: MyTaminViewController.ViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.myTaminStatus.value, id:\.self) { isDone in
                Circle()
                    .strokeBorder(Color(uiColor: UIColor.primaryColor), lineWidth: 1)
                    .foregroundColor(isDone ? Color(uiColor: UIColor.primaryColor) : Color.clear)
                    .frame(width: 12, height: 12)
            }
        }
    }
}
