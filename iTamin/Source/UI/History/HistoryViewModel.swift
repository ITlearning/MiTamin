//
//  HistoryViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import SwiftUI
import Combine

extension HistoryViewController {
    class ViewModel: ObservableObject {
        
        @Published var randomCareData: RandomCareModel? = nil
        
        var cancelBag = CancelBag()
        
        var networkManager = NetworkManager()
        
        func getCareRandomData() {
            networkManager.getCareRandom()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    if let value = value.data {
                        self.randomCareData = value
                    } else {
                        self.randomCareData = nil
                    }
                })
                .cancel(with: cancelBag)
        }
    }
}
