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
        label.font = UIFont.notoRegular(size: 18)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.notoRegular(size: 15)
        label.textColor = UIColor.black
        
        return label
    }()
    
    let nickNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setFont()
        textField.placeholder = "공백없이 9자 이내로 입력해주세요."
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
        button.titleLabel?.font = UIFont.notoMedium(size: 18)
        button.clipsToBounds = true
        button.isEnabled = false
        
        return button
    }()
    
    let goodNickNameDescription: UILabel = {
        let label = UILabel()
        label.text = "멋진 닉네임이네요 :)"
        label.font = UIFont.notoRegular(size: 13)
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
        
        
        viewModel.isValid
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                if value {
                    self.nextButton.isEnabled = true
                } else {
                    self.nextButton.isEnabled = false
                }
                
                self.nextButtonConfigure()
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
    }
    
    func nextButtonConfigure() {
        if nextButton.isEnabled {
            nextButton.backgroundColor = UIColor.buttonDone
            goodNickNameDescription.isHidden = false
            checkImageView.isHidden = false
        } else {
            nextButton.backgroundColor = UIColor.loginButtonGray
            goodNickNameDescription.isHidden = true
            checkImageView.isHidden = true
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(nickNameMainTitle)
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(checkImageView)
        view.addSubview(goodNickNameDescription)
        view.addSubview(nextButton)
        
        nickNameMainTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
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
