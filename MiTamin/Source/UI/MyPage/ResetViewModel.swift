//
//  ResetViewMoel.swift
//  MiTamin
//
//  Created by Tabber on 2022/11/07.
//

import Foundation
import Combine

extension ResetViewController {
    class ViewModel: ObservableObject {
        
        @Published var selectIndex: [Int] = [0,0,0]
        @Published var loading: Bool = false
        @Published var done: Bool = false
        var cancelBag = CancelBag()
        var networkManager = NetworkManager()
        
        func resetData() {
            loading = true
            self.done = false
            networkManager.resetData(array: selectIndex)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                    self.loading = false
                }, receiveValue: { value in
                    self.loading = false
                    self.done = true
                })
                .cancel(with: cancelBag)
        }
    }
}
