//
//  MyTaminViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/29.
//

import SwiftUI
import UIKit
import Combine

struct MyTaminModel {
    var image: String
    var mainTitle: String
    var subTitle: String
    
}

extension MyTaminViewController {
    class ViewModel: ObservableObject {
        var myTaminStatus = CurrentValueSubject<Int, Never>(1)
 
        var myTaminModel: [MyTaminModel] = [
            MyTaminModel(image: "myTaminTimerImage", mainTitle: "숨고르기", subTitle: "코로 천천히 숨을 들이 마셨다가\n배에 가득 담긴 공기를 잠시 느끼고\n천천히 내뱉어 보세요."),
            MyTaminModel(image: "myTaminTimerImage02", mainTitle: "감각 깨우기", subTitle: "편한 자세로 눈을 감고 주변의 소리에 귀를 기울여보세요. 다음에는 코로 들어오는 주변의 냄새를 느껴보고 손바닥에 느껴지는 감각에도 신경을 기울여봅니다.")
        ]
        
    }
}
