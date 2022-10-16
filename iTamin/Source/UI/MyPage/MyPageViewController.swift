//
//  MyPageViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/16.
//

import UIKit
import SwiftUI
import Combine
import SnapKit

class MyPageViewController: UIViewController {
    
    private let mainLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MyPageLogo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let helpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "help-circle"), for: .normal)
        
        return button
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_setting"), for: .normal)
        
        return button
    }()
    
    
    let profileBackGroundView = UIHostingController(rootView: ProfileBGView())
    
    private let profileEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"EditPencil"), for: .normal)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Mainillustration")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let profileMainLabel: UILabel = {
        let label = UILabel()
        label.text = "나를 가장 아껴줄 수 있는\n내가 될 태버 테스트"
        label.font = UIFont.SDGothicBold(size: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "icon-user-mono"), selectedImage: UIImage(named: "icon-user-mono"))
        configureLayout()
    }

    
    func configureLayout() {
        view.addSubview(mainLogo)
        view.addSubview(helpButton)
        view.addSubview(settingButton)
        
        let separateLine = UIView()
        separateLine.backgroundColor = UIColor.tabBarShadow
        view.addSubview(separateLine)
        
        view.addSubview(profileBackGroundView.view)
        view.addSubview(profileImageView)
        view.addSubview(profileEditButton)
        view.addSubview(profileMainLabel)
        
        mainLogo.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.width.equalTo(86)
            $0.height.equalTo(24)
        }
        
        settingButton.snp.makeConstraints {
            $0.top.equalTo(mainLogo)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        helpButton.snp.makeConstraints {
            $0.top.equalTo(mainLogo)
            $0.trailing.equalTo(settingButton.snp.leading).inset(-10)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        separateLine.snp.makeConstraints {
            $0.top.equalTo(mainLogo.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        profileBackGroundView.view.snp.makeConstraints {
            $0.top.equalTo(separateLine.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(profileBackGroundView.view.snp.leading).offset(36)
            $0.centerY.equalTo(profileBackGroundView.view.snp.centerY)
            $0.width.equalTo(72)
            $0.height.equalTo(72)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView.snp.bottom)
            $0.trailing.equalTo(profileImageView.snp.trailing)
            $0.width.equalTo(28)
            $0.height.equalTo(28)
        }
        
        profileMainLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileBackGroundView.view.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
    }
}

struct MyPageViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            MyPageViewController()
        }
        .previewDevice("iPhone 13")
    }
}
