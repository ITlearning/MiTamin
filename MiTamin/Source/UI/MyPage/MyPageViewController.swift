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
import Kingfisher
import SwiftKeychainWrapper
import SkeletonView

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
        imageView.image = UIImage(named: "mitamin")
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
    
    
    //let profileBackGroundView = UIHostingController(rootView: ProfileBGView())
    
    private let profileBackGroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG")
        
        return imageView
    }()
    
    private let profileEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"EditPencil"), for: .normal)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DefaultImage")
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
        label.textColor = .primaryColor
        label.isSkeletonable = true
        return label
    }()
    
    private let profileSubLabel: UILabel = {
        let label = UILabel()
        label.text = "내가 될 태버 테스트"
        label.font = UIFont.SDGothicBold(size: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isSkeletonable = true
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
    
    private let accountTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "일반 회원"
        label.textColor = UIColor.grayColor3
        label.font = UIFont.SDGothicRegular(size: 12)
        label.isSkeletonable = true
        return label
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
    
    private let ddayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicRegular(size: 13)
        label.textColor = .primaryColor
        
        return label
    }()
    
    private let roundView: UIView = {
        let customView = UIView()
        customView.backgroundColor = .clear
        customView.layer.cornerRadius = 12
        customView.layer.borderWidth = 1
        customView.layer.borderColor = UIColor.primaryColor.cgColor
        
        return customView
    }()
    
    
    private let demmedView = DemmedView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationConfigure()
        self.navigationController?.isNavigationBarHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(UserDefaults.standard.bool(forKey: "profileEdit"))
        if UserDefaults.standard.bool(forKey: "profileEdit") {
            viewModel.getProfile()
            setSkeleton()
            UserDefaults.standard.set(false, forKey: "profileEdit")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "icon-user-mono"), selectedImage: UIImage(named: "icon-user-mono"))
        configureLayout()
        setSkeleton()
        viewModel.getProfile()
        viewModel.getMyDayInfo()
        bindCombine()
    }
    
    func setSkeleton() {
        profileMainLabel.startSkeletonAnimation()
        profileMainLabel.showGradientSkeleton()
        profileSubLabel.startSkeletonAnimation()
        profileSubLabel.showGradientSkeleton()
        accountTypeLabel.startSkeletonAnimation()
        accountTypeLabel.showGradientSkeleton()
    }
    
    func setText() {
        
        
        profileMainLabel.text = viewModel.profileData.value?.beMyMessage ?? ""
        profileSubLabel.text = "내가 될 \(viewModel.profileData.value?.nickname ?? "")"
        accountTypeLabel.text = viewModel.profileData.value?.provider ?? ""
        if let url = viewModel.profileData.value?.profileImgUrl {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: URL(string: url)!)
        }
        
        profileMainLabel.stopSkeletonAnimation()
        profileMainLabel.hideSkeleton()
        profileSubLabel.stopSkeletonAnimation()
        profileSubLabel.hideSkeleton()
        accountTypeLabel.stopSkeletonAnimation()
        accountTypeLabel.hideSkeleton()
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
                print("안눌림?")
                let editProfileVC = EditProfileViewController(profile: self.viewModel.profileData.value ?? ProfileModel(nickname: "", beMyMessage: "", provider: ""))
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            })
            .cancel(with: cancelBag)
        
        myDayButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                let myDayVC = MyDayViewController()
                self.navigationController?.pushViewController(myDayVC, animated: true)
            })
            .cancel(with: cancelBag)
        
        viewModel.$myDayInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                guard let value = value else { return }
                self.setMyDayInfo(item: value)
            })
            .cancel(with: cancelBag)
        
        settingButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                let vc = SettingViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .cancel(with: cancelBag)
        
        
        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                if value {
                    self.demmedView.showDemmedPopup(text: "회원탈퇴 중..")
                } else {
                    self.demmedView.hide()
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.$userWithDrawal
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                if value {
                    UserDefaults.standard.set(false, forKey: "isLogined")
                    self.moveToLogin()
                }
            })
            .cancel(with: cancelBag)
    }
    
    func setMyDayInfo(item: MyDayModel) {
        myDayCountLabel.text = item.myDayMMDD
        lastMyDayLabel.text = item.comment
        ddayLabel.text = item.dday
    }
    
    func configureLayout() {
        
        view.addSubview(scrollView)
        view.addSubview(mainLogo)
        view.addSubview(helpButton)
        view.addSubview(settingButton)
        
        scrollView.addSubview(profileBackGroundView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(profileEditButton)
        scrollView.addSubview(profileMainLabel)
        scrollView.addSubview(profileSubLabel)
        scrollView.addSubview(accountTypeLabel)
        scrollView.addSubview(roundedRectangleView)
        roundedRectangleView.addSubview(myDayLabel)
        roundedRectangleView.addSubview(myDayLabelSub)
        roundedRectangleView.addSubview(myDayCountLabel)
        roundedRectangleView.addSubview(myDayButton)
        roundedRectangleView.addSubview(lastMyDayLabel)
        roundView.addSubview(ddayLabel)
        roundedRectangleView.addSubview(roundView)
        scrollView.addSubview(appInfoLabel)
        let seprateLineView = UIView()
        seprateLineView.backgroundColor = UIColor.backgroundColor2
        scrollView.addSubview(seprateLineView)
        
        let appInfoView = UIHostingController(rootView: AppInfoView())
        
        appInfoView.rootView.delegate = self
        
        scrollView.addSubview(appInfoView.view)
        
        mainLogo.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(14)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.width.equalTo(73)
            $0.height.equalTo(16)
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
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalToSuperview()
        }
        
        profileBackGroundView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(58)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).inset(20)
            $0.height.equalTo(134)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(68)
            $0.height.equalTo(68)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(70)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(32)
            $0.width.equalTo(28)
            $0.height.equalTo(28)
        }
        
        profileMainLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        profileSubLabel.snp.makeConstraints {
            $0.top.equalTo(profileMainLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        accountTypeLabel.snp.makeConstraints {
            $0.top.equalTo(profileSubLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        roundedRectangleView.snp.makeConstraints {
            $0.top.equalTo(profileBackGroundView.snp.bottom).offset(30)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).inset(20)
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
        
        ddayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        roundView.snp.makeConstraints {
            $0.leading.equalTo(myDayCountLabel.snp.trailing).offset(8)
            $0.top.equalTo(myDayCountLabel).offset(2)
            $0.width.equalTo(51)
            $0.height.equalTo(24)
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
            $0.leading.equalTo(scrollView.snp.leading)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(8)
        }
        
        appInfoLabel.snp.makeConstraints {
            $0.top.equalTo(seprateLineView.snp.bottom).offset(24)
            $0.leading.equalTo(scrollView.snp.leading).offset(20)
        }
        
        appInfoView.view.snp.makeConstraints {
            $0.top.equalTo(appInfoLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
        
    }
    
    func presentWithDrawalPopup() {
        let alertView = UIAlertController(title: "회원 탈퇴", message: "\(viewModel.profileData.value?.nickname ?? "")님, 정말 계정을 삭제하실 건가요?\n회원탈퇴 시 모든 정보가 사라지며 복구할 수 없습니다.", preferredStyle: .alert)
        
        let done = UIAlertAction(title: "탈퇴", style: .destructive) { _ in
            self.viewModel.withDrawal()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alertView.addAction(done)
        alertView.addAction(cancel)
        
        self.present(alertView, animated: true)
    }
    
    func presentLogoutPopup() {
        
        let alertView = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        let done = UIAlertAction(title: "확인", style: .destructive) { [weak self ] _ in
            guard let self = self else { return }
            UserDefaults.standard.set(false, forKey: "isLogined")
            self.moveToLogin()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alertView.addAction(done)
        alertView.addAction(cancel)
        self.present(alertView, animated: true)
    }
    
}

extension MyPageViewController: AppInfoDelegate {
    func touchAction(type: AppInfo) {
        print(type)
        
//        switch type {
//        case .Service:
//            
//        case .Privacy:
//            
//        case .Version:
//            
//        }
        
        switch type {
        case .LogOut:
            presentLogoutPopup()
        case .ResetData:
            let vc = ResetViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .PasswordChange:
            let vc = PasswordViewController(email: KeychainWrapper.standard.string(forKey: "userEmail") ?? "", type: .myTamin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .UserOut:
            presentWithDrawalPopup()
        default:
            print(type)
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
