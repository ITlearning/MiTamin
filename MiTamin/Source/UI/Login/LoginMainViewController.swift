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
        label.font = UIFont.SDGothicMedium(size: 18)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    private let mainLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mitaminLogin")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private let mainillustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LoginLogo")
        imageView.contentMode = .scaleAspectFill
        
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
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.primaryColor.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationConfigure()
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
                let vc = EmailCheckViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .cancel(with: cancelBag)
        
        signInButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                let loginVC = SignInViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
            })
            .cancel(with: cancelBag)
    }
    
    
    func buttonSetting() {
        signUpButton.setTitle("이메일로 가입하기", for: .normal)
        signUpButton.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        signUpButton.setTitleColor(UIColor.primaryColor, for: .normal)
        
        signInButton.setTitle("이메일로 로그인하기", for: .normal)
        signInButton.titleLabel?.font = UIFont.SDGothicBold(size: 16)
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
        
        mainLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(156)
            $0.width.equalTo(163)
            $0.height.equalTo(36)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainLogoImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        mainillustrationImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(10)
            $0.height.equalTo(168)
            $0.width.equalTo(144)
        }
        
        signInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainillustrationImageView.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(48)
        }
        
        signUpButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signInButton.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(48)
        }
        
        orLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signUpButton.snp.bottom).offset(30)
        }
        
        socialLoginImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(orLabel.snp.bottom).offset(18)
            $0.width.equalTo(49)
            $0.height.equalTo(49)
        }
        
        
    }

}
