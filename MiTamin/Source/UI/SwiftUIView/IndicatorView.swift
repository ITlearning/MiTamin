//
//  IndicatorView.swift
//  iTamin
//
//  Created by Tabber on 2022/09/29.
//

import SwiftUI

enum IndicatorType {
    case signUp
    case myTamin
}

struct IndicatorView: View {
    
    @StateObject var viewModel: MyTaminViewController.ViewModel
    var type: IndicatorType = .signUp
    @State var indicators: Int = 1
    @State var indicatorsDouble: Double = 0.0
    
    var body: some View {
        
        if type == .signUp {
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
        } else {
            HStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width * indicatorsDouble, height: 5)
                    .foregroundColor(Color(uiColor: UIColor.primaryColor))
                Spacer()
            }
            .onReceive(viewModel.myTaminStatus, perform: { value in
                withAnimation {
                    if value == 1 {
                        indicatorsDouble = 0.25
                    } else if value == 2 {
                        indicatorsDouble = 0.5
                    } else if value == 3 {
                        indicatorsDouble = 0.75
                    } else {
                        indicatorsDouble = 1
                    }
                }
            })
        }
        
        
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
