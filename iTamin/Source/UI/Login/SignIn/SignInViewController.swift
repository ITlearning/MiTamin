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
        button.setTitle("자동 로그인", for: .selected)
        button.setImage(UIImage(named: "check-circle"), for: .selected)
        button.setImage(UIImage(named: "UnSelectButton"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.black, for: .selected)
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
    
    let resetAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("아이디/비밀번호 찾기", for: .normal)
        button.setTitleColor(UIColor.nextTimeGray, for: .normal)
        button.titleLabel?.font = UIFont.notoRegular(size: 15)
        
        return button
    }()
    
    var errorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemRed
        label.font = UIFont.SDGothicMedium(size: 13)
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationConfigure(title: "이메일로 로그인")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bindCombine()
    }
    
    func bindCombine() {
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to: \.emailPublisher, on: viewModel)
            .cancel(with: cancelBag)
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to: \.passwordPublisher, on: viewModel)
            .cancel(with: cancelBag)

        viewModel.isValid
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] valid in
                guard let self = self else { return }
                print(valid)
                
                if self.viewModel.loginErrorText.value != "" {
                    self.viewModel.loginErrorText.send("")
                }
                
                if valid {
                    self.loginButton.isEnabled = true
                    self.buttonDone()
                } else {
                    self.loginButton.isEnabled = false
                    self.buttonNotDone()
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.loginErrorText
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { text in
                if text != "" {
                    self.emailTextField.underLine.backgroundColor = UIColor.systemRed
                    self.passwordTextField.underLine.backgroundColor = UIColor.systemRed
                    self.errorDescriptionLabel.text = text
                } else {
                    self.emailTextField.underLine.backgroundColor = UIColor.underLineGray
                    self.passwordTextField.underLine.backgroundColor = UIColor.underLineGray
                    self.errorDescriptionLabel.text = text
                }
            })
            .cancel(with: cancelBag)
        
        loginButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.tryToLogin(isAuto: self.autoLoginButton.isSelected)
            })
            .cancel(with: cancelBag)
        
        resetAccountButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                print("찾기 버튼")
            })
            .cancel(with: cancelBag)
        
        autoLoginButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.autoLoginButton.isSelected.toggle()
            })
            .cancel(with: cancelBag)
    }
    
    func buttonNotDone() {
        loginButton.backgroundColor = UIColor.loginButtonGray
    }
    
    func buttonDone() {
        loginButton.backgroundColor = UIColor.buttonDone
    }
    
    func configureLayout() {
        
        navigationConfigure()
        
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(autoLoginButton)
        view.addSubview(loginButton)
        view.addSubview(resetAccountButton)
        view.addSubview(errorDescriptionLabel)
        
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
        
        resetAccountButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(15)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        errorDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(autoLoginButton.snp.bottom).offset(20)
            $0.leading.equalTo(autoLoginButton.snp.leading)
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
