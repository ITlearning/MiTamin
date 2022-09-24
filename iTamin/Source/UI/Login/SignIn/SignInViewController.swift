//
//  SignInViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/23.
//

import UIKit
import SwiftUI
import SnapKit
import Combine
import CombineCocoa

class SignInViewController: UIViewController {

    private var cancelBag = CancelBag()
    private var viewModel = ViewModel()
    
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
    
    private let autoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("자동 로그인", for: .normal)
        button.setImage(UIImage(named: "check-circle"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.notoRegular(size: 15)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.loginButtonGray
        button.layer.cornerRadius = 8
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.notoMedium(size: 18)
        button.clipsToBounds = true
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bindCombine()
    }
    
    func bindCombine() {
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                guard let text = text else { return }
                guard let self = self else { return }
                
                self.viewModel.emailPublisher.send(text)
            })
            .cancel(with: cancelBag)
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                guard let text = text else { return }
                guard let self = self else { return }
                self.viewModel.passwordPublisher.send(text)
            })
            .cancel(with: cancelBag)

        
        viewModel.isValid
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] valid in
                guard let self = self else { return }
                print(valid)
                if valid {
                    self.loginButton.isUserInteractionEnabled = true
                    self.buttonDone()
                } else {
                    self.loginButton.isUserInteractionEnabled = false
                    self.buttonNotDone()
                }
            })
            .cancel(with: cancelBag)
    }
    
    func buttonNotDone() {
        loginButton.backgroundColor = UIColor.loginButtonGray
    }
    
    func buttonDone() {
        loginButton.backgroundColor = UIColor.buttonDone
    }
    
    func navigationConfigure() {
        let backButton = UIImage(named: "icon-arrow-left-small-mono")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = backButton
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.topItem?.title = "이메일로 로그인"
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButton
    }
    
    func configureLayout() {
        
        navigationConfigure()
        
        navigationController?.navigationBar.tintColor = UIColor.backButtonBlack
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(autoLoginButton)
        view.addSubview(loginButton)
        
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
        
        autoLoginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(14)
            $0.leading.equalTo(passwordTextField.snp.leading)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(autoLoginButton.snp.bottom).offset(73)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
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
