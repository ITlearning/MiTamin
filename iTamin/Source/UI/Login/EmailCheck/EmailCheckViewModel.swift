//
//  EmailCheckViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/11/06.
//

import Foundation
import Combine
import CombineCocoa

extension EmailCheckViewController {
    class ViewModel: ObservableObject {
        @Published var emailText: String = ""
        @Published var authCodeText: String = ""
        @Published var emailSuccess: Bool = false
        @Published var nextButtonOn: Bool = false
        @Published var emailAvailable: Bool = false
        var cancelBag = CancelBag()
        
        var networkManager = NetworkManager()
        
        func emailCheck() {
            networkManager.emailCheckToServer(string: emailText)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.emailAvailable = value.data
                })
                .cancel(with: cancelBag)
        }
        
        func checkEmailCode() {
            let model = EmailModel(email: emailText, authCode: authCodeText)
            networkManager.checkSuccessCode(model: model)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.nextButtonOn = value.data
                    print(value.data)
                })
                .cancel(with: cancelBag)
        }
        
        func checkEmailSignup() {
            networkManager.checkEmailSignUp(email: emailText)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    self.emailSuccess = true
                })
                .cancel(with: cancelBag)
        }
        
    }
}
