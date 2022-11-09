//
//  ResetPasswordViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/11/06.
//

import Foundation
import Combine

extension ResetPasswordViewController {
    class ViewModel: ObservableObject {
        @Published var emailText: String = ""
        @Published var successCodeText: String = ""
        @Published var emailAuthSuccess: Bool = false
        @Published var emailAvailable: Bool = false
        var sendRetry: Bool = false
        var emailSendState = PassthroughSubject<Bool, Never>()
        
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        
        func checkSuccessCode() {
            
            let model = EmailModel(email: emailText, authCode: successCodeText)
            
            networkManager.checkSuccessCode(model: model)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    self.emailAuthSuccess = value.data
                })
                .cancel(with: cancelBag)
        }
        
        func emailCheck() {
            networkManager.emailCheckToServer(string: emailText)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.emailAvailable = value.data
                })
                .cancel(with: cancelBag)
        }
        
        func getEmailReset() {
            networkManager.getEmailReset(email: emailText)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    self.emailSendState.send(true)
                })
                .cancel(with: cancelBag)
        }
        
        func isValidEmail(testStr:String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: testStr)
        }
    }
}
