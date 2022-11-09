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
    
    private let scrollView = UIScrollView()
    
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
    
    private var timer = Timer()
    
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
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(rgb: 0xF04452)
        label.font = UIFont.SDGothicRegular(size: 14)
        return label
    }()
    
    private var timerNum: Int = 300
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationConfigure(title: "비밀번호 찾기")
    }
    
    func startTimer() {
        if timer.isValid {
            timer.invalidate()
        }
        
        self.timerNum = 300
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc
    func updateTimerLabel() {
        if timerNum > 0 {
            timerNum -= 1
            
            let min = self.timerNum / 60
            let sec = self.timerNum % 60
            
            timerLabel.text = String(format: "%02d:%02d", min, sec)
        } else {
            timerLabel.text = "05:00"
            timer.invalidate()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        configureLayout()
        bindCombine()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
            var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)

            var contentInset:UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height + 20
            scrollView.contentInset = contentInset
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func setNextButton(isOpen: Bool) {
        if isOpen {
            stopTimer()
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
                if !self.viewModel.sendRetry {
                    self.emailComfirmButton.setImage(UIImage(named: "ReSend"), for: .normal)
                    self.viewModel.sendRetry = true
                    
                }
                self.startTimer()
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
        
        viewModel.$emailText
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                if value != "" && self?.viewModel.isValidEmail(testStr: value) ?? false {
                    self?.emailComfirmButton.isHidden = false
                    self?.viewModel.emailCheck()
                } else {
                    self?.emailComfirmButton.isHidden = true
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
        
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                let vc = PasswordViewController(email: self.viewModel.emailText)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .cancel(with: cancelBag)
    }
    
    @objc
    func doneTap() {
        view.endEditing(true)
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
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(passwordMainTitle)
        scrollView.addSubview(emailTextLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(successCodeTextField)
        scrollView.addSubview(emailComfirmButton)
        scrollView.addSubview(timerLabel)
        scrollView.addSubview(acceptCodeButton)
        
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneTap))
        bar.items = [reset]
        bar.sizeToFit()
        emailTextField.inputAccessoryView = bar
        successCodeTextField.inputAccessoryView = bar
        
        view.addSubview(nextButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        passwordMainTitle.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(44)
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
            $0.bottom.equalTo(scrollView.snp.bottom)
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
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
        
    }

}
