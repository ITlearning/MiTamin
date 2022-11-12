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
            UserDefaults.standard.set(selectIndex[0] == 1 ? true : false, forKey: "AllResetMind")
            UserDefaults.standard.set(selectIndex[1] == 1 ? true : false, forKey: "AllResetCare")
            UserDefaults.standard.set(selectIndex[2] == 1 ? true : false, forKey: "AllResetMyDay")
            UserDefaults.standard.set(true, forKey: "NeedUpdateHistory")
            UserDefaults.standard.set(true, forKey: "NeedUpdateMain")
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
