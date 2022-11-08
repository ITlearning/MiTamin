//
//  TermsViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import UIKit
import SwiftUI
import Combine
import CombineCocoa
import SnapKit

class TermsViewController: UIViewController {

    private var cancelBag = CancelBag()
    private var cancellable: AnyCancellable?
    private var viewModel: SignUpViewModel
    
    let termsMainTitle: UILabel = {
        let label = UILabel()
        label.text = "마이타민 서비스 이용약관에\n동의해 주세요."
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.grayColor4
        label.numberOfLines = 0
        return label
    }()
    
    let allSelectButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 동의하기", for: .normal)
        button.setTitle("전체 동의하기", for: .selected)
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        button.setTitleColor(UIColor.grayColor4, for: .selected)
        button.setImage(UIImage(named: "UnSelectButton"), for: .normal)
        button.setImage(UIImage(named: "check-circle"), for: .selected)
        
        return button
    }()
    
    
    let termsOneButton: UIButton = {
        let button = UIButton()
        button.setTitle("(필수) 이용약관에 동의합니다.", for: .normal)
        button.setTitle("(필수) 이용약관에 동의합니다.", for: .selected)
        button.setTitleColor(UIColor.grayColor2, for: .normal)
        button.setTitleColor(UIColor.grayColor2, for: .selected)
        button.setImage(UIImage(named: "UnSelectButton"), for: .normal)
        button.setImage(UIImage(named: "check-circle"), for: .selected)
        button.titleLabel?.font = UIFont.SDGothicRegular(size: 14)
        return button
    }()
    
    let termsTwoButton: UIButton = {
        let button = UIButton()
        button.setTitle("(필수) 개인정보 처리방침에 동의합니다.", for: .normal)
        button.setTitle("(필수) 개인정보 처리방침에 동의합니다.", for: .selected)
        button.setTitleColor(UIColor.grayColor2, for: .normal)
        button.setTitleColor(UIColor.grayColor2, for: .selected)
        button.setImage(UIImage(named: "UnSelectButton"), for: .normal)
        button.setImage(UIImage(named: "check-circle"), for: .selected)
        button.titleLabel?.font = UIFont.SDGothicRegular(size: 14)
        return button
    }()
    
    let termsViewOneButton: UIButton = {
        let button = UIButton()
        button.setTitle("보기", for: .normal)
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        button.titleLabel?.font = UIFont.SDGothicRegular(size: 14)
        return button
    }()
    
    let termsViewTwoButton: UIButton = {
        let button = UIButton()
        button.setTitle("보기", for: .normal)
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        button.titleLabel?.font = UIFont.SDGothicRegular(size: 14)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = CustomButton()
        button.backgroundColor = UIColor.loginButtonGray
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 8
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        button.clipsToBounds = true
        
        return button
    }()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationConfigure(title: "약관 동의")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        navigationConfigure()
        configureLayout()
        
        bindCombine()
    }
    
    func bindCombine() {
        allSelectButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.selectAll()
            })
            .cancel(with: cancelBag)
        
        termsOneButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.termsOneButton.isSelected = !self.termsOneButton.isSelected
                self.viewModel.oneButtonSelect = self.termsOneButton.isSelected
            })
            .cancel(with: cancelBag)
        
        termsTwoButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.termsTwoButton.isSelected = !self.termsTwoButton.isSelected
                self.viewModel.twoButtonSelect = self.termsTwoButton.isSelected
            })
            .cancel(with: cancelBag)
        
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let nickVC = NickNameViewController(viewModel: self.viewModel)
                self.navigationController?.pushViewController(nickVC, animated: false)
            })
            .cancel(with: cancelBag)
        
        viewModel.isAllSelect
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                if value {
                    self.nextButton.isEnabled = true
                    self.allSelectButton.isSelected = true
                } else {
                    self.nextButton.isEnabled = false
                    self.allSelectButton.isSelected = false
                }
                
                self.setButtonAble()
            })
            .cancel(with: cancelBag)
        
        
        
    }

    
    func selectAll() {
        if termsOneButton.isSelected && termsTwoButton.isSelected {
            allSelectButton.isSelected = false
            termsOneButton.isSelected = false
            termsTwoButton.isSelected = false
            viewModel.oneButtonSelect = false
            viewModel.twoButtonSelect = false
        } else {
            allSelectButton.isSelected = true
            termsOneButton.isSelected = true
            termsTwoButton.isSelected = true
            viewModel.oneButtonSelect = true
            viewModel.twoButtonSelect = true
        }
    }
    
    func setButtonAble() {
        if nextButton.isEnabled {
            nextButton.backgroundColor = UIColor.primaryColor
        } else {
            nextButton.backgroundColor = UIColor.loginButtonGray
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(termsMainTitle)
        view.addSubview(allSelectButton)
        view.addSubview(termsOneButton)
        view.addSubview(termsViewOneButton)
        view.addSubview(termsTwoButton)
        view.addSubview(termsViewTwoButton)
        view.addSubview(nextButton)
        let lineProgressView = UIHostingController(rootView: LineProgressBar(progress: 0.3, nextProgress: 0.6))
        view.addSubview(lineProgressView.view)
        lineProgressView.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        termsMainTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        allSelectButton.snp.makeConstraints {
            $0.top.equalTo(termsMainTitle.snp.bottom).offset(70)
            $0.leading.equalTo(termsMainTitle.snp.leading)
        }
        
        termsOneButton.snp.makeConstraints {
            $0.top.equalTo(allSelectButton.snp.bottom).offset(21)
            $0.leading.equalTo(allSelectButton.snp.leading)
        }
        
        termsViewOneButton.snp.makeConstraints {
            $0.centerY.equalTo(termsOneButton)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        termsTwoButton.snp.makeConstraints {
            $0.top.equalTo(termsOneButton.snp.bottom).offset(20)
            $0.leading.equalTo(termsOneButton.snp.leading)
        }
        
        termsViewTwoButton.snp.makeConstraints {
            $0.centerY.equalTo(termsTwoButton)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(24)
            $0.height.equalTo(56)
        }
    }
    
}
