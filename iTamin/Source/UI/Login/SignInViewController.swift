//
//  SignInViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/23.
//

import UIKit
import SwiftUI
import SnapKit

class SignInViewController: UIViewController {

    private let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.borderStyle = .none
        textField.placeholder = "이메일"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.borderStyle = .none
        textField.placeholder = "비밀번호"
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    func configureLayout() {
        
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        emailTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
    }

}


struct SignInViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SignInViewController()
        }
        .previewDevice("iPhone 13")
    }
}
