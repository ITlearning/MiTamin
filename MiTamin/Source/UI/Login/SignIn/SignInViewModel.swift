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
        
        @Published var loading: Bool = false
        
        private var networkManager = NetworkManager()
        private var cancelBag = CancelBag()
        var loginErrorText = CurrentValueSubject<String, Never>("")
        
        var isValid: AnyPublisher<Bool, Never> {
            Publishers
                .CombineLatest($emailPublisher, $passwordPublisher)
                .map({ email, password in
                    email.contains("@") &&
                    password.count > 7
                }).eraseToAnyPublisher()
        }
        
        func tryToLogin(isAuto: Bool) {
            loading = true
            networkManager.loginToServer(email: emailPublisher, password: passwordPublisher)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { error in
                    switch error {
                    case .finished: break
                    case .failure(let error):
                        switch error {
                        case .http(let data):
                            self.loginErrorText.send(data.message ?? "")
                            self.loading = false
                        case .unknown:
                            self.loginErrorText.send("로그인이 완료되지 않았습니다.")
                            self.loading = false
                        }
                    }
                }, receiveValue: { [weak self] result in
                    guard let self = self else { return }
                    self.loading = false
                    
                    if isAuto {
                        
                        UserDefaults.standard.set(true, forKey: "isLogined")
                        
                    }
                    
                    self.saveToken(accessToken: result.data.accessToken, refreshToken: result.data.refreshToken)
                    
                    let rootTabBarViewController = UINavigationController(rootViewController: RootTabBarViewController())
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
