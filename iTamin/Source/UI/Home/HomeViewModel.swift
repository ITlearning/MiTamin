//
//  HomeViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/27.
//

import UIKit
import SwiftUI
import SwiftKeychainWrapper
import Combine

extension HomeViewController {
    class ViewModel: ObservableObject {
        @Published var userData: WelComeModel?
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        
        @Published var mainCellItems: [MainCollectionModel] = [
            MainCollectionModel(isDone: false, cellDescription: "숨 고르기"),
            MainCollectionModel(isDone: false, cellDescription: "감각 깨우기"),
            MainCollectionModel(isDone: false, cellDescription: "하루 진단하기"),
            MainCollectionModel(isDone: false, cellDescription: "칭찬 처방하기")
        ]
        
        init() {
            loadWelComeComment()
        }
        
        func loadWelComeComment() {
            networkManager.welcomeToServer()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] result in
                    guard let self = self else {return}
                    print(result.statusCode)
                    self.userData = result.data
                })
                .cancel(with: cancelBag)
        }
    }
}
