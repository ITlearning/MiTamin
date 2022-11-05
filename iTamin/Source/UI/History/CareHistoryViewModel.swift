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
        
        @Published var careList: [CategoryCareModel] = []
        
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
                    
                    self.careList = temp
                })
                .cancel(with: cancelBag)
        }
    }
}
