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
        
        init() {
            loadWelComeComment()
        }
        
        func loadWelComeComment() {
            networkManager.welcomeToServer()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] result in
                    guard let self = self else {return}
                    self.userData = result.data ?? WelComeModel(nickname: "", comment: "")
                })
                .cancel(with: cancelBag)
        }
    }
}
