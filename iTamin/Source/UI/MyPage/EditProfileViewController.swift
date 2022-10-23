//
//  EditProfileViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/10/23.
//

import UIKit
import SwiftUI
import Combine
import SnapKit

class EditProfileViewController: UIViewController {
    
    private var viewModel = ViewModel()
    private var cancelBag = CancelBag()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Mainillustration")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 61
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let profileImageSelectButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "EditImage"), for: .normal)
        return button
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicMedium(size: 12)
        label.text = "닉네임"
        label.textColor = UIColor.grayColor3
        
        return label
    }()
    
    private let nickNameTextField: CustomTextField2 = {
        let textField = CustomTextField2()
        textField.setFont()
        
        return textField
    }()
    
    private let subMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "되고 싶은 내 모습"
        label.font = UIFont.SDGothicMedium(size: 12)
        label.textColor = UIColor.grayColor3
        
        return label
    }()
    
    
    private let subMessageTextField: CustomTextField2 = {
        let textField = CustomTextField2()
        textField.setFont()
        
        return textField
    }()
    
    private let subMessageLastLabel: UILabel = {
        let label = UILabel()
        label.text = "내가 될"
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.SDGothicMedium(size: 16)
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationConfigure(title: "프로필 편집")
    }
    
    
    init(profile: ProfileModel) {
        viewModel.userData = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureLayout()
        setUI()
        bindCombine()
        
    }
    
    func bindCombine() {
        nickNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to: \.nickNameTextFieldString, on: viewModel)
            .cancel(with: cancelBag)
        
        subMessageTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0 ?? "" })
            .assign(to: \.subMessageTextFieldString, on: viewModel)
            .cancel(with: cancelBag)
        
        doneButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.editProfile()
            })
            .cancel(with: cancelBag)
    }
    
    func setUI() {
        nickNameTextField.text = viewModel.userData?.nickname ?? ""
        subMessageTextField.text = viewModel.userData?.beMyMessage ?? ""
    }
    
    func configureLayout() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageSelectButton)
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(subMessageLabel)
        view.addSubview(subMessageTextField)
        view.addSubview(subMessageLastLabel)
        view.addSubview(doneButton)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(122)
            $0.height.equalTo(122)
        }
        
        profileImageSelectButton.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView)
            $0.trailing.equalTo(profileImageView)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nickNameLabel)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(50)
        }
        
        subMessageLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(40)
            $0.leading.equalTo(nickNameLabel)
        }
        
        subMessageLastLabel.snp.makeConstraints {
            $0.centerY.equalTo(subMessageTextField)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        subMessageTextField.snp.makeConstraints {
            $0.top.equalTo(subMessageLabel.snp.bottom).offset(8)
            $0.leading.equalTo(subMessageLabel)
            $0.trailing.equalTo(subMessageLastLabel.snp.leading).offset(-20)
            $0.height.equalTo(48)
            $0.width.equalTo(277)
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
    }

}
