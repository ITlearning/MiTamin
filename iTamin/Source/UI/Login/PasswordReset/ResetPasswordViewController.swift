//
//  ResetPasswordViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/11/06.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit

class ResetPasswordViewController: UIViewController {

    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    private let passwordMainTitle: UILabel = {
        let label = UILabel()
        label.text = "가입할 때 사용한\n이메일을 입력해주세요."
        label.textAlignment = .left
        label.font = UIFont.SDGothicBold(size: 24)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let emailTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor2
        label.text = "이메일"
        label.font = UIFont.SDGothicRegular(size: 12)
        
        return label
    }()
    
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "내용입력"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let successCodeTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "인증코드"
        return textField
    }()
    
    private let emailComfirmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "emailComfirm"), for: .normal)
        
        return button
    }()
    
    private let timer = Timer()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "05:00"
        label.textColor = .grayColor2
        label.font = UIFont.SDGothicMedium(size: 14)
        
        return label
    }()
    
    private let acceptCodeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Accept"), for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.grayColor7
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationConfigure(title: "비밀번호 찾기")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        bindCombine()
    }
    
    func setNextButton(isOpen: Bool) {
        if isOpen {
            nextButton.backgroundColor = UIColor.primaryColor
        } else {
            nextButton.backgroundColor = UIColor.grayColor7
        }
    }
    
    func setAcceptButton(isOpen: Bool) {
        if isOpen {
            acceptCodeButton.setImage(UIImage(named: "AcceptOn"), for: .normal)
            acceptCodeButton.isEnabled = true
        } else {
            acceptCodeButton.setImage(UIImage(named: "Accept"), for: .normal)
            acceptCodeButton.isEnabled = false
        }
    }
    
    private func bindCombine() {
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to: \.emailText, on: viewModel)
            .cancel(with: cancelBag)
        
        
        successCodeTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to: \.successCodeText, on: viewModel)
            .cancel(with: cancelBag)
        
        viewModel.emailSendState
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                self.setAcceptButton(isOpen: value)
            })
            .cancel(with: cancelBag)
        
        emailComfirmButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                self.viewModel.getEmailReset()
            })
            .cancel(with: cancelBag)
        
        acceptCodeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                self.viewModel.checkSuccessCode()
            })
            .cancel(with: cancelBag)
        
        viewModel.$emailAuthSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                self.setNextButton(isOpen: value)
            })
            .cancel(with: cancelBag)
    }
    
    private func configureLayout() {
        view.addSubview(passwordMainTitle)
        view.addSubview(emailTextLabel)
        view.addSubview(emailTextField)
        view.addSubview(successCodeTextField)
        view.addSubview(emailComfirmButton)
        view.addSubview(timerLabel)
        view.addSubview(acceptCodeButton)
        
        passwordMainTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        emailTextLabel.snp.makeConstraints {
            $0.top.equalTo(passwordMainTitle.snp.bottom).offset(40)
            $0.leading.equalTo(passwordMainTitle.snp.leading)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextLabel.snp.bottom).offset(20)
            $0.leading.equalTo(emailTextLabel.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(40)
        }
        
        emailComfirmButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.top)
            $0.trailing.equalTo(emailTextField.snp.trailing)
            $0.width.equalTo(66)
            $0.height.equalTo(24)
        }
        
        successCodeTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(40)
            $0.leading.equalTo(emailTextField.snp.leading)
            $0.trailing.equalTo(emailTextField.snp.trailing)
            $0.height.equalTo(40)
        }
        
        acceptCodeButton.snp.makeConstraints {
            $0.top.equalTo(successCodeTextField.snp.top)
            $0.trailing.equalTo(successCodeTextField.snp.trailing)
            $0.width.equalTo(66)
            $0.height.equalTo(24)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(acceptCodeButton.snp.top).offset(5)
            $0.trailing.equalTo(successCodeTextField.snp.trailing).inset(78)
        }
        
    }

}
