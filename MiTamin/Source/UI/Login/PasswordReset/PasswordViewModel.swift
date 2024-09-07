//
//  PasswordViewModel.swift
//  MiTamin
//
//  Created by Tabber on 2022/11/07.
//

import Foundation
import Combine

extension PasswordViewController {
    
    class ViewModel: ObservableObject {
        var cancelBag = CancelBag()
        var networkManager = NetworkManager()
        var email: String = ""
        var type: ViewType = .signIn
        @Published var passwordText: String = ""
        @Published var passwordCheckText: String = ""
        @Published var passwordChangeSuccess: Bool = false
        @Published var loading: Bool = false
        
        var goToMain = PassthroughSubject<Bool, Never>()
        
        var userDataIsValid: AnyPublisher<Bool, Never> {
            return Publishers.CombineLatest($passwordText, $passwordCheckText)
                .map { password, passwordCheck in
                    return (password.count > 8 && password.count < 30) && password == passwordCheck
                }
                .eraseToAnyPublisher()
        }
        
        
        func validpassword(mypassword : String) -> Bool {
            let passwordreg =  ("(?=.*[A-Za-z])(?=.*[0-9]).{8,30}")
            let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
            return passwordtesting.evaluate(with: mypassword)
        }
        
        var passwordCheckPublisher: AnyPublisher<Bool, Never> {
            return $passwordText
                .map { text in
                    return self.validpassword(mypassword: text)
                }
                .eraseToAnyPublisher()
        }
        
        var passwordBetweenCheck: AnyPublisher<Bool, Never> {
            return $passwordCheckText
                .map { text in
                    return self.passwordText == text
                }
                .eraseToAnyPublisher()
        }
        
        func resetPassword() {
            loading = false
            
            // 코드 수정 필요합니다.
            /*
            if type == .signIn {
                
                networkManager.resetPassword(email: email, password: passwordCheckText)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in
                        self.loading = false
                    }, receiveValue: { value in
                        self.passwordChangeSuccess = true
                        self.loading = false
                    })
                    .cancel(with: cancelBag)
            } else {
                networkManager.changePassword(password: passwordCheckText)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in
                        self.loading = false
                    }, receiveValue: { _ in
                        self.passwordChangeSuccess = true
                        self.loading = false
                    })
                    .cancel(with: cancelBag)
            }
             */
        }
           
    }
}
