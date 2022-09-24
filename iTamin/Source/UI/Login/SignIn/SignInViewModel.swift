//
//  SignInViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import UIKit
import Combine
import CombineCocoa

extension SignInViewController {
    class ViewModel: ObservableObject {
        var emailPublisher = CurrentValueSubject<String, Never>("")
        var passwordPublisher = CurrentValueSubject<String, Never>("")
        
        var isValid: AnyPublisher<Bool, Never> {
            Publishers
                .CombineLatest(emailPublisher, passwordPublisher)
                .allSatisfy({ email, password in
                    email.contains("@") &&
                    password.count > 7
                }).eraseToAnyPublisher()
        }
        
    }
}
