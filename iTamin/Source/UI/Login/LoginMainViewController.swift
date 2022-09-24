//
//  LoginMainViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/23.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

enum LoginButtonType {
    case signUp
    case signIn
}


class LoginMainViewController: UIViewController {

    private var cancelBag = CancelBag()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "매일 챙겨먹는 마음 비타민"
        label.font = UIFont.notoBold(size: 15)
        label.textColor = UIColor.black
        
        return label
    }()
    private let mainLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainLogo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private let mainillustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Mainillustration")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "또는"
        label.font = UIFont.notoRegular(size: 15)
        label.textColor = UIColor.black
        
        return label
    }()
    private let socialLoginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SocialLogin")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.loginButtonGray
        button.layer.cornerRadius = 24.5
        button.clipsToBounds = true
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.loginButtonGray
        button.layer.cornerRadius = 24.5
        button.clipsToBounds = true
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        buttonSetting()
        bindButtons()
    }
    
    
    
    func bindButtons() {
        
        signUpButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                print("회원가입 버튼 클릭")
            })
            .cancel(with: cancelBag)
        
        signInButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                print("왜 안됨")
                let loginVC = SignInViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
            })
            .cancel(with: cancelBag)
    }
    
    
    func buttonSetting() {
        signUpButton.setTitle("이메일로 가입하기", for: .normal)
        signUpButton.titleLabel?.font = UIFont.notoMedium(size: 18)
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        
        signInButton.setTitle("이메일로 로그인하기", for: .normal)
        signInButton.titleLabel?.font = UIFont.notoMedium(size: 18)
        signInButton.setTitleColor(UIColor.white, for: .normal)
    }

    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(mainTitleLabel)
        view.addSubview(mainLogoImageView)
        view.addSubview(mainillustrationImageView)
        view.addSubview(signUpButton)
        view.addSubview(signInButton)
        view.addSubview(orLabel)
        view.addSubview(socialLoginImageView)
        
        mainTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(90)
        }
        
        mainLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(10)
            $0.width.equalTo(190)
            $0.height.equalTo(70)
        }
        
        mainillustrationImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainLogoImageView.snp.bottom).offset(10)
            $0.height.equalTo(174)
            $0.width.equalTo(174)
        }
        
        signUpButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainillustrationImageView.snp.bottom).offset(97)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.height.equalTo(49)
        }
        
        signInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signUpButton.snp.bottom).offset(9)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.height.equalTo(49)
        }
        
        orLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signInButton.snp.bottom).offset(30)
        }
        
        socialLoginImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(orLabel.snp.bottom).offset(18)
            $0.width.equalTo(49)
            $0.height.equalTo(49)
        }
        
        
    }

}
