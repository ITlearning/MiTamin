//
//  MyPageViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/16.
//

import UIKit
import SwiftUI
import Combine
import CombineCocoa
import SnapKit

class MyPageViewController: UIViewController {
    
    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    private let scrollView: UIScrollView = {
        let scrolLView = UIScrollView()
        
        return scrolLView
    }()
    
    private let containerView = UIView()
    
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
        label.text = "나를 가장 아껴줄 수 있는"
        label.font = UIFont.SDGothicBold(size: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let profileSubLabel: UILabel = {
        let label = UILabel()
        label.text = "내가 될 태버 테스트"
        label.font = UIFont.SDGothicMedium(size: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let roundedRectangleView: UIView = {
        let roundView = UIView()
        roundView.layer.cornerRadius = 12
        roundView.layer.borderColor = UIColor.grayColor5.cgColor
        roundView.layer.borderWidth = 1
        roundView.backgroundColor = .clear
        return roundView
    }()
    
    private let myDayLabel: UILabel = {
        let label = UILabel()
        label.text = "마이데이"
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = UIColor.grayColor4
        return label
    }()
    
    private let myDayLabelSub: UILabel = {
        let label = UILabel()
        label.text = "이번 달 마이데이는"
        label.font = UIFont.SDGothicMedium(size: 14)
        label.textColor = UIColor.grayColor3
        
        return label
    }()
    
    private let myDayCountLabel: UILabel = {
        let label = UILabel()
        label.text = "00월 00일"
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    private let lastMyDayLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 마이데이에는 무엇을 해볼까요?"
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicMedium(size: 16)
        
        return label
    }()
    
    private let myDayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myDayButtonArrow"), for: .normal)
        button.setTitle("마이데이 바로가기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 8
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return button
    }()
    
    private let appInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "앱정보"
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    private let accountSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정관리", for: .normal)
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        button.titleLabel?.font = UIFont.SDGothicMedium(size: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    
    private let serviceInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("서비스 이용약관", for: .normal)
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.SDGothicMedium(size: 16)
        return button
    }()
    
    private let userDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("개인정보 처리방침", for: .normal)
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.SDGothicMedium(size: 16)
        return button
    }()
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        label.text = "버전"
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor4
        return label
    }()
    
    private let appVersionStatus: UILabel = {
        let label = UILabel()
        label.text = "최신버전 입니다."
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor2
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationConfigure()
        self.navigationController?.isNavigationBarHidden = true
        viewModel.getProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "icon-user-mono"), selectedImage: UIImage(named: "icon-user-mono"))
        configureLayout()
        bindCombine()
    }
    
    func setText() {
        profileMainLabel.text = viewModel.profileData.value?.beMyMessage ?? ""
        profileSubLabel.text = "내가 될 \(viewModel.profileData.value?.nickname ?? "")"
    }
    
    func bindCombine() {
        viewModel.profileData
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.setText()
            })
            .cancel(with: cancelBag)
        
        profileEditButton.tapPublisher
            .sink(receiveCompletion: {_ in}, receiveValue: { _ in
                let editProfileVC = EditProfileViewController(profile: self.viewModel.profileData.value ?? ProfileModel(nickname: "", beMyMessage: ""))
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            })
            .cancel(with: cancelBag)
    }
    
    func configureLayout() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        view.addSubview(mainLogo)
        view.addSubview(helpButton)
        view.addSubview(settingButton)
        
        //scrollView.addSubview()
        containerView.addSubview(profileBackGroundView.view)
        containerView.addSubview(profileImageView)
        containerView.addSubview(profileEditButton)
        containerView.addSubview(profileMainLabel)
        containerView.addSubview(profileSubLabel)
        containerView.addSubview(roundedRectangleView)
        roundedRectangleView.addSubview(myDayLabel)
        roundedRectangleView.addSubview(myDayLabelSub)
        roundedRectangleView.addSubview(myDayCountLabel)
        roundedRectangleView.addSubview(myDayButton)
        roundedRectangleView.addSubview(lastMyDayLabel)
        containerView.addSubview(appInfoLabel)
        containerView.addSubview(accountSettingButton)
        containerView.addSubview(serviceInfoButton)
        containerView.addSubview(userDataButton)
        containerView.addSubview(appVersionLabel)
        containerView.addSubview(appVersionStatus)
        let seprateLineView = UIView()
        seprateLineView.backgroundColor = UIColor.backgroundColor2
        containerView.addSubview(seprateLineView)
        
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
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(settingButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
        }
        
        profileBackGroundView.view.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(34)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(92)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(profileBackGroundView.view.snp.top).offset(12)
            $0.leading.equalTo(profileBackGroundView.view.snp.leading).offset(32)
            $0.width.equalTo(72)
            $0.height.equalTo(72)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView.snp.bottom)
            $0.trailing.equalTo(profileImageView.snp.trailing)
        }
        
        profileMainLabel.snp.makeConstraints {
            $0.top.equalTo(profileBackGroundView.view.snp.top).offset(26)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(24)
        }
        
        profileSubLabel.snp.makeConstraints {
            $0.top.equalTo(profileMainLabel.snp.bottom).offset(5)
            $0.leading.equalTo(profileMainLabel)
        }
        
        roundedRectangleView.snp.makeConstraints {
            $0.top.equalTo(profileBackGroundView.view.snp.bottom).offset(30)
            $0.leading.equalTo(containerView.snp.leading).offset(20)
            $0.trailing.equalTo(containerView.snp.trailing).inset(20)
            $0.height.equalTo(220)
        }
        
        myDayLabel.snp.makeConstraints {
            $0.top.equalTo(roundedRectangleView.snp.top).offset(16)
            $0.leading.equalTo(roundedRectangleView.snp.leading).offset(16)
        }
        
        myDayLabelSub.snp.makeConstraints {
            $0.top.equalTo(myDayLabel.snp.bottom).offset(20)
            $0.leading.equalTo(myDayLabel)
        }
        
        myDayCountLabel.snp.makeConstraints {
            $0.top.equalTo(myDayLabelSub.snp.bottom).offset(8)
            $0.leading.equalTo(myDayLabel)
        }
        
        lastMyDayLabel.snp.makeConstraints {
            $0.top.equalTo(myDayCountLabel.snp.bottom).offset(24)
            $0.leading.equalTo(myDayLabel)
        }
        
        myDayButton.snp.makeConstraints {
            $0.top.equalTo(lastMyDayLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        seprateLineView.snp.makeConstraints {
            $0.top.equalTo(roundedRectangleView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        appInfoLabel.snp.makeConstraints {
            $0.top.equalTo(seprateLineView.snp.bottom).offset(24)
            $0.leading.equalTo(containerView.snp.leading).offset(20)
        }
        accountSettingButton.snp.makeConstraints {
            $0.top.equalTo(appInfoLabel.snp.bottom).offset(24)
            $0.leading.equalTo(appInfoLabel.snp.leading)
            $0.trailing.equalTo(containerView.snp.trailing).inset(20)
            $0.height.equalTo(40)
        }
        
        serviceInfoButton.snp.makeConstraints {
            $0.top.equalTo(accountSettingButton.snp.bottom)
            $0.leading.equalTo(appInfoLabel)
            $0.trailing.equalTo(containerView.snp.trailing).inset(20)
            $0.height.equalTo(40)
        }
        
        userDataButton.snp.makeConstraints {
            $0.top.equalTo(serviceInfoButton.snp.bottom)
            $0.leading.equalTo(appInfoLabel)
            $0.height.equalTo(40)
        }
        
        appVersionLabel.snp.makeConstraints {
            $0.top.equalTo(userDataButton.snp.bottom).offset(10)
            $0.leading.equalTo(appInfoLabel)
        }
        
        appVersionStatus.snp.makeConstraints {
            $0.top.equalTo(appVersionLabel.snp.top)
            $0.trailing.equalTo(containerView.snp.trailing).inset(20)
            $0.bottom.equalTo(containerView.snp.bottom)
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
