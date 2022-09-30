//
//  IndicatorView.swift
//  iTamin
//
//  Created by Tabber on 2022/09/29.
//

import SwiftUI

struct IndicatorView: View {
    
    @StateObject var viewModel: MyTaminViewController.ViewModel
    @State var indicators: Int = 2
    
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...4, id:\.self) { idx in
                circleView(idx: idx)
            }
        }
        .onReceive(viewModel.myTaminStatus, perform: { value in
            withAnimation {
                indicators = value
            }
        })
    }
    
    func circleView(idx: Int) -> some View {
        ZStack {
            Circle()
                .strokeBorder(Color(uiColor: UIColor.primaryColor), lineWidth: 1)
                .frame(width: 12, height: 12)
            Circle()
                .foregroundColor(indicators >= idx ? Color(uiColor: UIColor.primaryColor) : Color.clear)
                .frame(width: 12, height: 12)
            
        }
        
        
        
    }
}
