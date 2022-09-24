//
//  OnBoardingViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import SwiftUI
import Combine
import CombineCocoa

extension OnBoardingViewController {
    class ViewModel: ObservableObject {
        var descriptionArray: [String] = []
        
        @Published var currentInex: Int = 0
        var userName: String = ""
        
        func setDescription() {
            descriptionArray = ["안녕하세요, \(userName)님!\n매일 챙겨먹는 마음 비타민\n마이타민입니다!",
                                "하루의 끝에서\n오늘의 나를 진단해보고\n칭찬 처방을 내려보세요",
                                "적어도 한달에 한번은\n오로지 자신의 행복을 위한\n하루가 되도록 도울게요.",
                                "하루를 마무리하는 시간은\n 언제쯤 인가요?"]
        }
    }
}
