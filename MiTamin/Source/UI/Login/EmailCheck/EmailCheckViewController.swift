//
//  EmailCheckViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/11/06.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit
import SwiftUI

class EmailCheckViewController: UIViewController {

    private let scrollView = UIScrollView()
    
    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "나를 위한 마음 비타민,\n오늘부터 섭취해 보시겠어요?"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = UIColor.grayColor2
        label.font = UIFont.SDGothicRegular(size: 12)
        
        return label
    }()
    
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "이메일을 입력해주세요."
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let authCodeTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "인증번호를 입력해주세요."
        textField.autocapitalizationType = .none
        textField.isHidden = true
        return textField
    }()
    
    private let timer = Timer()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "05:00"
        label.textColor = .grayColor2
        label.font = UIFont.SDGothicMedium(size: 14)
        label.isHidden = true
        return label
    }()
    
    private let acceptCodeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Accept"), for: .normal)
        button.isEnabled = false
        button.isHidden = true
        return button
    }()
    
    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(rgb: 0xF04452)
        label.font = UIFont.SDGothicRegular(size: 14)
        return label
    }()
    
    private let emailComfirmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "emailComfirm"), for: .normal)
        
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
        navigationConfigure(title: "회원가입")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationConfigure(title: "회원가입")
        configureLayout()
        bindCombine()
    }
    
    
    private func bindCombine() {
        
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in
                let vc = SignUpViewController(email: self.viewModel.emailText)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .cancel(with: cancelBag)
        
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .throttle(for: 1.5, scheduler: RunLoop.main, latest: true)
            .map({ $0 ?? "" })
            .assign(to: \.emailText, on: viewModel)
            .cancel(with: cancelBag)
        
        viewModel.$emailText
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                if value != "" {
                    self?.viewModel.emailCheck()
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.$emailAvailable
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                if self.viewModel.emailText != "" {
                    if value {
                        self.emailErrorLabel.text = "사용할 수 없는 이메일 주소에요!"
                        self.emailErrorLabel.textColor = UIColor(rgb: 0xF04452)
                    } else {
                        self.emailErrorLabel.text = "사용 가능한 이메일 주소에요!"
                        self.emailErrorLabel.textColor = UIColor.primaryColor
                    }
                } else {
                    self.emailErrorLabel.text = ""
                }
            })
            .cancel(with: cancelBag)
        
        emailComfirmButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.checkEmailSignup()
            })
            .cancel(with: cancelBag)
        
        viewModel.$emailSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                if value {
                    self.setAccept(isOpen: value)
                    self.authCodeTextField.isHidden = false
                    self.timerLabel.isHidden = false
                    self.acceptCodeButton.isHidden = false
                }
            })
            .cancel(with: cancelBag)
        
        acceptCodeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.checkEmailCode()
            })
            .cancel(with: cancelBag)
        
        viewModel.$nextButtonOn
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.setNextButton(isOpen: value)
            })
            .cancel(with: cancelBag)
        
    }
    
    func setNextButton(isOpen: Bool) {
        if isOpen {
            nextButton.backgroundColor = .primaryColor
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = .grayColor7
            nextButton.isEnabled = true
        }
    }
    
    func setAccept(isOpen: Bool) {
        if isOpen {
            acceptCodeButton.setImage(UIImage(named: "AcceptOn"), for: .normal)
            acceptCodeButton.isEnabled = true
        } else {
            acceptCodeButton.setImage(UIImage(named: "Accept"), for: .normal)
            acceptCodeButton.isEnabled = false
        }
    }
    
    private func configureLayout() {
        let lineProgressView = UIHostingController(rootView: LineProgressBar(progress: 0.3))
        view.addSubview(lineProgressView.view)
        view.addSubview(scrollView)
        scrollView.addSubview(mainTitleLabel)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(emailErrorLabel)
        scrollView.addSubview(emailComfirmButton)
        scrollView.addSubview(authCodeTextField)
        scrollView.addSubview(timerLabel)
        scrollView.addSubview(acceptCodeButton)
        
        view.addSubview(nextButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(40)
            $0.leading.equalTo(mainTitleLabel.snp.leading)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(20)
            $0.leading.equalTo(emailLabel.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(40)
        }
        
        emailComfirmButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.top)
            $0.trailing.equalTo(emailTextField.snp.trailing)
            $0.width.equalTo(66)
            $0.height.equalTo(24)
        }
        
        emailErrorLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(12)
            $0.leading.equalTo(emailTextField.snp.leading)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
        
        lineProgressView.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        authCodeTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(40)
            $0.leading.equalTo(emailTextField.snp.leading)
            $0.trailing.equalTo(emailTextField.snp.trailing)
            $0.height.equalTo(40)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(authCodeTextField.snp.top).offset(2)
            $0.trailing.equalTo(authCodeTextField.snp.trailing).inset(98)
        }
        
        acceptCodeButton.snp.makeConstraints {
            $0.top.equalTo(authCodeTextField.snp.top)
            $0.trailing.equalTo(authCodeTextField.snp.trailing)
            $0.width.equalTo(66)
            $0.height.equalTo(24)
        }
        
    }

}
