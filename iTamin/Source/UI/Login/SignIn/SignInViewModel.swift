//
//  SignInViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import UIKit
import Combine
import CombineCocoa
import SwiftKeychainWrapper

extension SignInViewController {
    class ViewModel: ObservableObject {
        @Published var emailPublisher: String = ""
        @Published var passwordPublisher: String = ""
        private var networkManager = NetworkManager()
        private var cancelBag = CancelBag()
        
        var isValid: AnyPublisher<Bool, Never> {
            Publishers
                .CombineLatest($emailPublisher, $passwordPublisher)
                .map({ email, password in
                    email.contains("@") &&
                    password.count > 7
                }).eraseToAnyPublisher()
        }
        
        func tryToLogin() {
            networkManager.loginToServer(email: emailPublisher, password: passwordPublisher)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] result in
                    guard let self = self else { return }
                    
                    UserDefaults.standard.set(true, forKey: "isLogined")
                    
                    self.saveToken(accessToken: result.data.accessToken, refreshToken: result.data.refreshToken)
                    
                    let rootTabBarViewController = RootTabBarViewController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(rootTabBarViewController, animated: true)
                })
                .cancel(with: cancelBag)
        }
        
        func saveToken(accessToken: String, refreshToken: String) {
            KeychainWrapper.standard.set(accessToken, forKey: "accessToken")
            KeychainWrapper.standard.set(refreshToken, forKey: "refreshToken")
        }
        
    }
}
