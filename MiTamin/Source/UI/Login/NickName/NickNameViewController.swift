//
//  NickNameViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit
import SwiftUI

class NickNameViewController: UIViewController {

    private var cancelBag = CancelBag()
    private var viewModel: SignUpViewModel
    let nickNameMainTitle: UILabel = {
        let label = UILabel()
        label.text = "마이타민에서 사용할\n닉네임을 입력해주세요."
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.grayColor4
        label.numberOfLines = 0
        return label
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.SDGothicRegular(size: 12)
        label.textColor = UIColor.grayColor2
        
        return label
    }()
    
    let nickNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setFont()
        textField.clearButtonMode = .always
        textField.placeholder = "내용입력"
        return textField
    }()
    
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "check")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let nextButton: UIButton = {
        let button = CustomButton()
        button.backgroundColor = UIColor.loginButtonGray
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 8
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        button.clipsToBounds = true
        button.isEnabled = false
        
        return button
    }()
    
    let goodNickNameDescription: UILabel = {
        let label = UILabel()
        label.text = "멋진 닉네임이네요 :)"
        label.font = UIFont.SDGothicRegular(size: 14)
        label.textColor = UIColor.goodNickGray
        label.isHidden = true
        return label
    }()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationConfigure(title: "가입 완료")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureLayout()
        bindCombine()
    }
    
    func bindCombine() {
        nickNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                guard let text = text else { return }
                guard let self = self else { return }
                self.viewModel.typingText(text)
            })
            .cancel(with: cancelBag)
        
        viewModel.$nickNameText
            .throttle(for: 1, scheduler: RunLoop.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { text in
                if text != "" {
                    self.viewModel.checkNickName(text: text)
                }
            })
            .cancel(with: cancelBag)
        
        
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                let onboardingVC = OnBoardingViewController(viewModel: self.viewModel)
                onboardingVC.modalPresentationStyle = .fullScreen
                self.present(onboardingVC, animated: true)
                
            })
            .cancel(with: cancelBag)
        
        viewModel.nickNameCheck
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                self.checkNickNameDescription(isCheck: value)
                
                if !value {
                    self.nextButton.isEnabled = true
                } else {
                    self.nextButton.isEnabled = false
                }
                self.nextButtonConfigure()
            })
            .cancel(with: cancelBag)
        
        
        viewModel.signUpSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            })
            .cancel(with: cancelBag)
    }
    
    func checkNickNameDescription(isCheck: Bool) {
        if !isCheck {
            goodNickNameDescription.text = "사용 가능한 닉네임이에요!"
            goodNickNameDescription.textColor = .primaryColor
        } else {
            goodNickNameDescription.text = "사용할 수 없는 닉네임이에요!"
            goodNickNameDescription.textColor = .deleteRed
        }
        
    }
    
    func nextButtonConfigure() {
        if nextButton.isEnabled {
            nextButton.backgroundColor = UIColor.primaryColor
            goodNickNameDescription.isHidden = false
        } else {
            nextButton.backgroundColor = UIColor.loginButtonGray
        }
    }
    
    @objc
    func doneTap() {
        view.endEditing(true)
    }
    
    func configureLayout() {
        
        
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneTap))
        bar.items = [reset]
        bar.sizeToFit()
        nickNameTextField.inputAccessoryView = bar
        
        view.backgroundColor = .white
        view.addSubview(nickNameMainTitle)
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(checkImageView)
        view.addSubview(goodNickNameDescription)
        view.addSubview(nextButton)
        let lineProgressView = UIHostingController(rootView: LineProgressBar(progress: 0.6, nextProgress: 1.1))
        view.addSubview(lineProgressView.view)
        lineProgressView.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        nickNameMainTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameMainTitle.snp.bottom).offset(24)
            $0.leading.equalTo(nickNameMainTitle)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(25)
            $0.leading.equalTo(nickNameMainTitle.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalTo(nickNameTextField)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(24)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        goodNickNameDescription.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(2)
            $0.leading.equalTo(nickNameTextField.snp.leading)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(24)
            $0.height.equalTo(56)
        }
    }
    
}
