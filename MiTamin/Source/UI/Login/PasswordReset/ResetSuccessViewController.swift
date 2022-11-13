//
//  ResetSuccessViewController.swift
//  MiTamin
//
//  Created by Tabber on 2022/11/07.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa


class ResetSuccessViewController: UIViewController {

    var cancelBag = CancelBag()
    var type: ViewType = .signIn
    var viewModel: PasswordViewController.ViewModel
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-check-circle-line-mono-1")
        
        return imageView
    }()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 변경이\n성공적으로 완료되었어요!"
        label.textAlignment = .center
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.grayColor4
        label.numberOfLines = 0
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "다시 마이타민을 시작하러 갈까요?"
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor3
        label.numberOfLines = 0
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인 하러 가기", for: .normal)
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    init(viewModel: PasswordViewController.ViewModel, type: ViewType = .signIn) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if type != .signIn {
            nextButton.setTitle("마이페이지로 가기", for: .normal)
        } else {
            nextButton.setTitle("로그인하러 가기", for: .normal)
        }
        
        hideKeyboardWhenTappedAround()
        configureLayout()
        bindCombine()
    }
    
    private func configureLayout() {
        view.addSubview(imageView)
        view.addSubview(mainTitleLabel)
        view.addSubview(subLabel)
        view.addSubview(nextButton)
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(197)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
    }
    
    private func bindCombine() {
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                self.viewModel.goToMain.send(true)
                self.dismiss(animated: true)
            })
            .cancel(with: cancelBag)
    }
    

}
