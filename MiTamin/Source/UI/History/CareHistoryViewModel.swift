//
//  CareHistoryViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import Foundation
import Combine
import CombineCocoa
import SwiftUI

extension CareHistoryViewController {
    class ViewModel: ObservableObject {
        
        @Published var careList: [CategoryCareModel] = []
        
        @Published var selectIndex: [Int] = []
        
        @Published var loading: Bool = false
        
        var menuTexts:[String] = [
            "이루어 낸 일",
            "잘한 일이나 행동",
            "노력하고 있는 부분",
            "긍정적인 변화나 깨달음",
            "감정, 생각 혹은 신체 일부분",
            "과거의 나",
            "기타"
        ]
        
        var cancelBag = CancelBag()
        var networkManager = NetworkManager()
        
        func getCategoryCareData(category: [Int] = []) {
            withAnimation {
                self.loading = true
            }
            networkManager.getCategoryCareList(filter: category)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                    withAnimation {
                        self.loading = false
                    }
                }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.careList.removeAll()
                    var temp: [CategoryCareModel] = []
                    value.data.forEach { (key, value) in
                        temp.append(CategoryCareModel(date: key, data: value))
                    }

                    print("결과", temp)
                    self.careList = temp
                    
                    withAnimation {
                        self.loading = false
                    }
                })
                .cancel(with: cancelBag)
        }
    }
}
