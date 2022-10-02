//
//  SignUpViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import UIKit
import SwiftUI
import Combine
import CombineCocoa
import SnapKit

class SignUpViewController: UIViewController {

    private var cancelBag = CancelBag()
    private var viewModel: SignUpViewModel = SignUpViewModel()
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "나를 위한 마음 비타민,\n오늘부터 섭취해 보시겠어요?"
        label.font = UIFont.notoRegular(size: 18)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = UIFont.notoRegular(size: 15)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private let passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.notoRegular(size: 15)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private let passwordCheckTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.font = UIFont.notoRegular(size: 15)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setFont()
        textField.autocapitalizationType = .none
        textField.placeholder = "이메일을 입력해주세요."
        
        return textField
    }()
    
    private let emailSubDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoRegular(size: 13)
        label.textColor = UIColor.onboadingSubTitleGray
        
        return label
    }()
    
    private let passwordSubDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoRegular(size: 13)
        label.textColor = UIColor.onboadingSubTitleGray
        
        return label
    }()
    
    private let passwordCheckSubDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoRegular(size: 13)
        label.textColor = UIColor.onboadingSubTitleGray
        
        return label
    }()
    
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "check")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
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
        textField.placeholder = "영문,숫자를 포함한 8~30자리 조합으로 설정해주세요."
        
        return textField
    }()
    
    private let passwordCheckTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setFont()
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.placeholder = "비밀번호 확인을 위해 다시 한번 비밀번호를 입력해주세요."
        
        return textField
    }()
    
    let nextButton: UIButton = {
        let button = CustomButton()
        button.backgroundColor = UIColor.loginButtonGray
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 8
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.notoMedium(size: 18)
        button.clipsToBounds = true
        button.isEnabled = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationConfigure(title: "회원 가입")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        bindCombine()
    }
    
    func bindCombine() {
        
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let termsVC = TermsViewController(viewModel: self.viewModel)
                self.navigationController?.pushViewController(termsVC, animated: false)
            })
            .cancel(with: cancelBag)
        
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to: \.emailText, on: viewModel)
            .cancel(with: cancelBag)
        
        viewModel.$emailText
            .throttle(for: 1.5, scheduler: RunLoop.main, latest: true)
            .sink(receiveValue: { [weak self] text in
                if !text.isEmpty && self?.viewModel.isValidEmail(testStr: text) ?? false {
                    self?.viewModel.checkEmail(text: text)
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.emailCheck.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.checkEmailStatus(value)
            })
            .cancel(with: cancelBag)
        
        viewModel.passwordCheckPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if !(self?.viewModel.passwordText.isEmpty ?? false) {
                    self?.checkPasswordValidStatue(value)
                }
            }
            .cancel(with: cancelBag)
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to: \.passwordText, on: viewModel)
            .cancel(with: cancelBag)
        
        viewModel.passwordBetweenCheck
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.checkBetweenPassword(value)
            }
            .cancel(with: cancelBag)
        
        passwordCheckTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to: \.passwordCheckText, on: viewModel)
            .cancel(with: cancelBag)
        
        viewModel.userDataIsValid
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                print(value)
                if value {
                    self.nextButton.isEnabled = true
                } else {
                    self.nextButton.isEnabled = false
                }
                self.setButton()
            })
            .cancel(with: cancelBag)
        
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
    }
    
    func checkEmailStatus(_ value: Bool) {
        if value {
            emailSubDescription.text = "이미 사용 중인 이메일입니다."
            checkImageView.isHidden = true
        } else {
            emailSubDescription.text = "사용 가능한 이메일입니다."
            checkImageView.isHidden = false
        }
    }
    
    func checkPasswordValidStatue(_ value: Bool) {
        if value {
            passwordSubDescription.text = "사용 가능한 비밀번호입니다."
        } else {
            passwordSubDescription.text = "영문, 숫자를 포함한 8~30자리 조합으로 설정해주세요."
        }
    }
    
    func checkBetweenPassword(_ value: Bool) {
        if value {
            passwordCheckSubDescription.text = "비밀번호가 일치합니다."
        } else {
            passwordCheckSubDescription.text = "비밀번호가 일치하지 않습니다."
        }
    }
    
    
    
    func setButton() {
        if nextButton.isEnabled {
            nextButton.backgroundColor = UIColor.buttonDone
        } else {
            nextButton.backgroundColor = UIColor.loginButtonGray
        }
        
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(mainTitleLabel)
        view.addSubview(emailTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTitleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordCheckTitleLabel)
        view.addSubview(passwordCheckTextField)
        view.addSubview(nextButton)
        view.addSubview(emailSubDescription)
        view.addSubview(passwordSubDescription)
        view.addSubview(passwordCheckSubDescription)
        view.addSubview(checkImageView)
        view.addSubview(passwordHiddenButton)
        view.addSubview(passwordCheckHiddenButton)
        let lineProgressView = UIHostingController(rootView: LineProgressBar(progress: 0.3))
        view.addSubview(lineProgressView.view)
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(28)
            $0.leading.equalTo(mainTitleLabel.snp.leading)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(emailTitleLabel.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        emailSubDescription.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(2)
            $0.leading.equalTo(emailTextField)
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalTo(emailTextField)
            $0.trailing.equalTo(emailTextField)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        passwordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(40)
            $0.leading.equalTo(emailTextField.snp.leading)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(emailTextField)
        }
        
        passwordSubDescription.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(2)
            $0.leading.equalTo(passwordTextField)
        }
        
        passwordHiddenButton.snp.makeConstraints {
            $0.centerY.equalTo(passwordTextField)
            $0.trailing.equalTo(passwordTextField)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        passwordCheckTitleLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(40)
            $0.leading.equalTo(passwordTextField.snp.leading)
        }
        
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(passwordTextField)
        }
        
        passwordCheckSubDescription.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTextField.snp.bottom).offset(2)
            $0.leading.equalTo(passwordCheckTextField)
        }
        
        passwordCheckHiddenButton.snp.makeConstraints {
            $0.centerY.equalTo(passwordCheckTextField)
            $0.trailing.equalTo(passwordCheckTextField)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(24)
            $0.height.equalTo(56)
        }
        
        lineProgressView.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


struct SignUpViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SignUpViewController()
        }
        .previewDevice("iPhone 13")
    }
}
