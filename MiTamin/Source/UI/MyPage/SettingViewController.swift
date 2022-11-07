//
//  SettingViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/11/06.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import LocalAuthentication

class SettingViewController: UIViewController {

    private let scrollView = UIScrollView()
    
    private let checkLock = BiometricsAuth()
    private var cancelBag = CancelBag()
    private let settingMainLabel: UILabel = {
        let label = UILabel()
        label.text = "부가기능"
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicBold(size: 18)
        return label
    }()
    
    private let eatAlertLabel: UILabel = {
        let label = UILabel()
        label.text = "섭취 알림"
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicBold(size: 16)
        
        return label
    }()
    
    private let eatAlertSubLabel: UILabel = {
        let label = UILabel()
        label.text = "지정한 시간에 마이타민 섭취 알림을 받을게요."
        label.textColor = UIColor.grayColor3
        label.font = UIFont.SDGothicRegular(size: 14)
        
        return label
    }()
    
    private let lockLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 잠금"
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicBold(size: 16)
        
        return label
    }()
    
    private let lockSubLabel: UILabel = {
        let label = UILabel()
        label.text = "앱을 시작할 때 잠금해제가 필요해요."
        label.textColor = UIColor.grayColor3
        label.font = UIFont.SDGothicRegular(size: 14)
        
        return label
    }()
    
    private let myDayLabel: UILabel = {
        let label = UILabel()
        label.text = "마이데이 알림"
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicBold(size: 16)
        
        return label
    }()
    
    private let myDaySubLabel: UILabel = {
        let label = UILabel()
        label.text = "마이데이가 다가오면 알림을 받을게요."
        label.textColor = UIColor.grayColor3
        label.font = UIFont.SDGothicRegular(size: 14)
        
        return label
    }()

    private let eatToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.tintColor = UIColor(rgb: 0xFFEB85)
        toggle.onTintColor = UIColor(rgb: 0xFFEB85)
        return toggle
    }()
    
    private let lockToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.tintColor = UIColor(rgb: 0xFFEB85)
        toggle.onTintColor = UIColor(rgb: 0xFFEB85)
        return toggle
    }()
    
    private let myDayToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.tintColor = UIColor(rgb: 0xFFEB85)
        toggle.onTintColor = UIColor(rgb: 0xFFEB85)
        return toggle
    }()
    
    private let eatAlertView = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigure(title: "설정")
        view.backgroundColor = .white
        configureLayout()
        bindCombine()
    }
    
    private func bindCombine() {
        
        self.checkLock.delegate = self
        
        lockToggle.isOnPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                //self.checkLock.execute()
            })
            .cancel(with: cancelBag)
    }
    
    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(settingMainLabel)
        scrollView.addSubview(eatAlertLabel)
        scrollView.addSubview(eatAlertSubLabel)
        scrollView.addSubview(eatToggle)
        scrollView.addSubview(eatAlertView)
        eatAlertView.backgroundColor = .gray
        let sepOne = UIView()
        sepOne.backgroundColor = UIColor(rgb: 0xEDEDED)
        scrollView.addSubview(sepOne)
        
        scrollView.addSubview(lockLabel)
        scrollView.addSubview(lockSubLabel)
        scrollView.addSubview(lockToggle)
        
        let sepTwo = UIView()
        sepTwo.backgroundColor = UIColor(rgb: 0xEDEDED)
        scrollView.addSubview(sepTwo)
        scrollView.addSubview(myDayLabel)
        scrollView.addSubview(myDaySubLabel)
        scrollView.addSubview(myDayToggle)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        settingMainLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(24)
            $0.leading.equalTo(scrollView.snp.leading).offset(20)
        }
        
        eatAlertLabel.snp.makeConstraints {
            $0.top.equalTo(settingMainLabel.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        eatAlertSubLabel.snp.makeConstraints {
            $0.top.equalTo(eatAlertLabel.snp.bottom).offset(12)
            $0.leading.equalTo(eatAlertLabel.snp.leading)
        }
        
        eatToggle.snp.makeConstraints {
            $0.top.equalTo(eatAlertLabel.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.width.equalTo(46)
            $0.height.equalTo(28)
        }
        
        eatAlertView.snp.makeConstraints {
            $0.top.equalTo(eatAlertSubLabel.snp.bottom).offset(14)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(40)
        }
        
        sepOne.snp.makeConstraints {
            $0.top.equalTo(eatAlertView.snp.bottom).offset(24)
            $0.leading.equalTo(eatAlertView.snp.leading)
            $0.trailing.equalTo(eatAlertView.snp.trailing)
            $0.height.equalTo(1)
        }
        
        lockLabel.snp.makeConstraints {
            $0.top.equalTo(sepOne.snp.bottom).offset(30)
            $0.leading.equalTo(sepOne.snp.leading)
        }
        
        lockSubLabel.snp.makeConstraints {
            $0.top.equalTo(lockLabel.snp.bottom).offset(12)
            $0.leading.equalTo(lockLabel.snp.leading)
        }
        
        lockToggle.snp.makeConstraints {
            $0.top.equalTo(lockLabel.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.width.equalTo(46)
            $0.height.equalTo(28)
        }
        
        sepTwo.snp.makeConstraints {
            $0.top.equalTo(lockSubLabel.snp.bottom).offset(24)
            $0.leading.equalTo(lockSubLabel.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(1)
        }
        
        myDayLabel.snp.makeConstraints {
            $0.top.equalTo(sepTwo.snp.bottom).offset(30)
            $0.leading.equalTo(sepTwo.snp.leading)
        }
        
        myDaySubLabel.snp.makeConstraints {
            $0.top.equalTo(myDayLabel.snp.bottom).offset(12)
            $0.leading.equalTo(myDayLabel.snp.leading)
        }
        
        myDayToggle.snp.makeConstraints {
            $0.top.equalTo(myDayLabel.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.width.equalTo(46)
            $0.height.equalTo(28)
        }
    }
}

extension SettingViewController: AuthenticateStateDelegate  {
    func didUpdateState(_ state: BiometricsAuth.AuthenticationState) {
        switch state {
        case .loggedIn:
            print("로그인 성공")
        case .LoggedOut:
            print("로그아웃 성공")
        }
    }
    
    
}
