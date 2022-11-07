//
//  PasswordViewController.swift
//  MiTamin
//
//  Created by Tabber on 2022/11/07.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit

class PasswordViewController: UIViewController {
    
    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    private let scrollView = UIScrollView()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "새롭게 사용하실\n비밀번호를 입력해주세요."
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.grayColor4
        label.numberOfLines = 0
        return label
    }()
    
    private let passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.SDGothicRegular(size: 12)
        label.textColor = UIColor.grayColor2
        
        return label
    }()
    
    private let passwordCheckTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.font = UIFont.SDGothicRegular(size: 12)
        label.textColor = UIColor.grayColor2
        
        return label
    }()
    
    let passwordHiddenButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "eye-off"), for: .normal)
        button.setImage(UIImage(named: ""), for: .selected)
        
        return button
    }()
    
    let passwordCheckHiddenButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "eye-off"), for: .normal)
        button.setImage(UIImage(named: ""), for: .selected)
        
        return button
    }()
    
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setFont()
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.placeholder = "영문,숫자를 포함한 8~30자리 조합으로 설정"
        
        return textField
    }()
    
    private let passwordCheckTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setFont()
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.placeholder = "비밀번호 확인을 위한 재입력을 해주세요."
        
        return textField
    }()
    
    private let passwordSubDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoRegular(size: 13)
        label.textColor = UIColor.deleteRed
        
        return label
    }()
    
    private let passwordCheckSubDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoRegular(size: 13)
        label.textColor = UIColor.deleteRed
        
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        button.backgroundColor = UIColor.grayColor7
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let demmedView = DemmedView()
    
    init(email: String) {
        viewModel.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationConfigure(title: "비밀번호 재설정")
        bindCombine()
        configureLayout()
    }
    
    private func bindCombine() {
        passwordHiddenButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                if self.passwordTextField.isSecureTextEntry {
                    self.passwordTextField.isSecureTextEntry = false
                } else {
                    self.passwordTextField.isSecureTextEntry = true
                }
            })
            .cancel(with: cancelBag)
        
        passwordCheckHiddenButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                if self.passwordCheckTextField.isSecureTextEntry {
                    self.passwordCheckTextField.isSecureTextEntry = false
                } else {
                    self.passwordCheckTextField.isSecureTextEntry = true
                }
            })
            .cancel(with: cancelBag)
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to:\.passwordText, on: viewModel)
            .cancel(with: cancelBag)
        
        passwordCheckTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to: \.passwordCheckText, on: viewModel)
            .cancel(with: cancelBag)
        
        viewModel.passwordCheckPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if !(self?.viewModel.passwordText.isEmpty ?? false) {
                    self?.checkPasswordValidStatue(value)
                }
            }
            .cancel(with: cancelBag)
        
        viewModel.passwordBetweenCheck
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.checkBetweenPassword(value)
            }
            .cancel(with: cancelBag)
        
        viewModel.userDataIsValid
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                if value {
                    self?.nextButton.isEnabled = true
                } else {
                    self?.nextButton.isEnabled = false
                }
                self?.setButton()
            })
            .cancel(with: cancelBag)
        
        viewModel.$passwordChangeSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                if value {
                    let vc = ResetSuccessViewController(viewModel: self.viewModel)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else {return}
                if value {
                    self.demmedView.showDemmedPopup(text: "비밀번호를 변경하는 중입니다..")
                } else {
                    self.demmedView.hide()
                }
            })
            .cancel(with: cancelBag)
        
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                self.viewModel.resetPassword()
            })
            .cancel(with: cancelBag)
        
        viewModel.goToMain
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            })
            .cancel(with: cancelBag)
    }
    
    
    
    func setButton() {
        if nextButton.isEnabled {
            nextButton.backgroundColor = UIColor.primaryColor
        } else {
            nextButton.backgroundColor = UIColor.loginButtonGray
        }
        
    }
    
    
    func checkPasswordValidStatue(_ value: Bool) {
        if value {
            passwordSubDescription.text = "사용 가능한 비밀번호에요!"
            passwordSubDescription.textColor = .primaryColor
        } else {
            passwordSubDescription.text = "사용할 수 없는 비밀번호에요!"
            passwordSubDescription.textColor = .deleteRed
        }
    }
    
    func checkBetweenPassword(_ value: Bool) {
        if value {
            if viewModel.passwordCheckText != "" {
                passwordCheckSubDescription.text = "비밀번호가 일치해요!"
                passwordCheckSubDescription.textColor = UIColor.primaryColor
            } else {
                passwordCheckSubDescription.text = ""
            }
        } else {
            passwordCheckSubDescription.text = "비밀번호가 일치하지 않아요!"
            passwordCheckSubDescription.textColor = UIColor.deleteRed
        }
    }
    
    private func configureLayout() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(mainTitleLabel)
        scrollView.addSubview(passwordTitleLabel)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(passwordHiddenButton)
        scrollView.addSubview(passwordCheckTitleLabel)
        scrollView.addSubview(passwordCheckTextField)
        scrollView.addSubview(passwordCheckHiddenButton)
        scrollView.addSubview(passwordSubDescription)
        scrollView.addSubview(passwordCheckSubDescription)
        
        view.addSubview(nextButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(44)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        passwordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTitleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(40)
        }
        
        passwordHiddenButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.top)
            $0.leading.equalTo(passwordTextField.snp.trailing).inset(20)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        passwordSubDescription.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(12)
            $0.leading.equalTo(passwordTextField.snp.leading)
        }
        
        passwordCheckTitleLabel.snp.makeConstraints {
            $0.top.equalTo(passwordSubDescription.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTitleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(40)
        }
        
        passwordCheckHiddenButton.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTextField.snp.top)
            $0.trailing.equalTo(passwordCheckTextField.snp.trailing)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        passwordCheckSubDescription.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTextField.snp.bottom).offset(12)
            $0.leading.equalTo(passwordCheckTextField.snp.leading)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
    }
}
