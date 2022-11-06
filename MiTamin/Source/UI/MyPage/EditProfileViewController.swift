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
import YPImagePicker
import Kingfisher

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
    
    let imageSelectView = UIView()
    let defaultImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("기본 이미지 선택", for: .normal)
        button.titleLabel?.font = UIFont.SDGothicMedium(size: 16)
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        
        return button
    }()
    
    let albumImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("앨범에서 사진 선택", for: .normal)
        button.titleLabel?.font = UIFont.SDGothicMedium(size: 16)
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        
        return button
    }()
    
    let blackBackView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureLayout()
        setUI()
        bindCombine()
        
    }
    
    func showImageSelector() {
        viewModel.isOpen = true
        UIView.animate(withDuration: 0.4, delay: 0, options: .transitionCurlUp, animations: {
            self.imageSelectView.snp.remakeConstraints {
                $0.top.equalTo(self.view.snp.bottom).inset(154)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(154)
            }
            self.blackBackView.alpha = 0.6
            self.imageSelectView.superview?.layoutIfNeeded()
        })
    }
    
    func hideImageSelector() {
        viewModel.isOpen = false
        UIView.animate(withDuration: 0.4, delay: 0, options: .transitionCurlDown, animations: {
            self.imageSelectView.snp.remakeConstraints {
                $0.top.equalTo(self.view.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(154)
            }
            self.blackBackView.alpha = 0.0
            self.imageSelectView.superview?.layoutIfNeeded()
        })
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
        
        profileImageSelectButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                if self.viewModel.isOpen {
                    self.hideImageSelector()
                } else {
                    self.showImageSelector()
                }
            })
            .cancel(with: cancelBag)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        
        blackBackView.addGestureRecognizer(tapGesture)
        
        defaultImageButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.profileImageView.image = UIImage(systemName: "person.fill")
                self.viewModel.imageEdit = true
                self.viewModel.editImage = UIImage(systemName: "person.fill")
            })
            .cancel(with: cancelBag)
        
        albumImageButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.selectPhoto()
            })
            .cancel(with: cancelBag)
        
        viewModel.profileEditSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in}, receiveValue: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .cancel(with: cancelBag)
    }
    
    @objc func tapAction() {
        if self.viewModel.isOpen {
            self.hideImageSelector()
        } else {
            self.showImageSelector()
        }
    }
    
    
    func selectPhoto() {
        var config = YPImagePickerConfiguration()
        config.wordings.libraryTitle = "갤러리"
        config.startOnScreen = .library
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "확인"
        
        let picker = YPImagePicker()
        
        picker.didFinishPicking { items, cancelled in
            if let photo = items.singlePhoto {
                self.viewModel.editImage = photo.image
                self.viewModel.imageEdit = true
                self.profileImageView.image = photo.image
            }
            picker.dismiss(animated: true)
            self.hideImageSelector()
        }
        present(picker, animated: true)
    }
    
    func setUI() {
        nickNameTextField.text = viewModel.userData?.nickname ?? ""
        subMessageTextField.text = viewModel.userData?.beMyMessage ?? ""
        if let url = viewModel.userData?.profileImgUrl {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: URL(string: url)!)
        }
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
        view.addSubview(blackBackView)
        blackBackView.backgroundColor = .black
        blackBackView.alpha = 0.0
        view.addSubview(imageSelectView)
        imageSelectView.clipsToBounds = true
        imageSelectView.layer.cornerRadius = 10
        imageSelectView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        imageSelectView.backgroundColor = .white
        
        imageSelectView.addSubview(defaultImageButton)
        imageSelectView.addSubview(albumImageButton)
        
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
        
        imageSelectView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(154)
        }
        
        defaultImageButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        albumImageButton.snp.makeConstraints {
            $0.top.equalTo(defaultImageButton.snp.bottom).offset(40)
            $0.leading.equalTo(defaultImageButton)
        }
        
        blackBackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view)
        }
    }

}
