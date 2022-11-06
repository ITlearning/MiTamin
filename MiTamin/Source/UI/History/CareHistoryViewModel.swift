//
//  CareHistoryViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import Foundation
import Combine
import CombineCocoa

extension CareHistoryViewController {
    class ViewModel: ObservableObject {
        
        @Published var careList: [CategoryCareModel] = [
            CategoryCareModel(date: "2022년 9월", data: [
                CareFilterModel(careMsg1: "오늘 계획했던 일을 전부 했어.", careMsg2: "성실하려 노력하는 내 모습이 좋아.", careCategory: "이루어낸 일", takeAt: "09.01. Thu"),
                CareFilterModel(careMsg1: "오늘 계획했던 일을 전부 했어.", careMsg2: "성실하려 노력하는 내 모습이 좋아.", careCategory: "이루어낸 일", takeAt: "09.01. Thu"),
            ]),
            CategoryCareModel(date: "2022년 8월", data:[
                CareFilterModel(careMsg1: "오늘 계획했던 일을 전부 했어.", careMsg2: "성실하려 노력하는 내 모습이 좋아.", careCategory: "이루어낸 일", takeAt: "09.01. Thu"),
                CareFilterModel(careMsg1: "오늘 계획했던 일을 전부 했어.", careMsg2: "성실하려 노력하는 내 모습이 좋아.", careCategory: "이루어낸 일", takeAt: "09.01. Thu")
            ])
        ]
        
        @Published var selectIndex: [Int] = []
        
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
            networkManager.getCategoryCareList(filter: category)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.careList.removeAll()
                    var temp: [CategoryCareModel] = []
                    value.data.forEach { (key, value) in
                        temp.append(CategoryCareModel(date: key, data: value))
                    }
                    
                    print("결과", temp)
                    self.careList = temp
                })
                .cancel(with: cancelBag)
        }
    }
}
