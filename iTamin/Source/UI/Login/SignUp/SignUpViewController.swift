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
        textField.placeholder = "이메일을 입력해주세요."
        
        return textField
    }()
    
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setFont()
        textField.placeholder = "영문,숫자를 포함한 8~30자리 조합으로 설정해주세요."
        
        return textField
    }()
    
    private let passwordCheckTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setFont()
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
        
        //navigationConfigure()
        configureLayout()
        bindCombine()
    }
    
    func bindCombine() {
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                print("다음")
                let termsVC = TermsViewController()
                self.navigationController?.pushViewController(termsVC, animated: false)
            })
            .cancel(with: cancelBag)
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
        
        passwordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(40)
            $0.leading.equalTo(emailTextField.snp.leading)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(emailTextField)
        }
        
        passwordCheckTitleLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(40)
            $0.leading.equalTo(passwordTextField.snp.leading)
        }
        
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(passwordTextField)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(24)
            $0.height.equalTo(56)
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
