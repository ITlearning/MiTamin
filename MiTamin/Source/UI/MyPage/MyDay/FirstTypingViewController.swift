//
//  FirstTypingViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/10/26.
//

import UIKit
import Combine
import SnapKit

protocol CustomTextFieldDelegate: AnyObject {
    func sendToText(text: String)
}

class FirstTypingViewController: UIViewController {

    weak var delegate: CustomTextFieldDelegate?
    
    var cancelBag = CancelBag()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationConfigure(title: "마이데이")
    }
    
    private let currentLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 리스트"
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    let textField: UITextField = {
        let textField = CustomTextField3()
        textField.borderStyle = .none
        textField.font = UIFont.SDGothicMedium(size: 16)
        textField.textColor = UIColor.grayColor4
        textField.layer.borderColor = UIColor.grayColor5.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8.0
        textField.placeholder = "내용 입력"
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성하기", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        button.alpha = 0.0001
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        configureLayout()
        getNotification()
        bindCombine()
    }
    
    func bindCombine() {
        doneButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.delegate?.sendToText(text: self.textField.text ?? "")
                self.navigationController?.popViewController(animated: true)
            })
            .cancel(with: cancelBag)
    }
    
    func getNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    @objc
    func keyboardDidShow(_ notification: NSNotification) {
        let keyboardSize:CGSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
         let height = min(keyboardSize.height, keyboardSize.width)
        
        UIView.animate(withDuration: 0.2) {
            self.doneButton.snp.remakeConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(12 - height)
                $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
                $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(20)
                $0.height.equalTo(56)
            }
            
            self.doneButton.superview?.layoutIfNeeded()
        }
        
    }
    
    @objc
    func keyboardDidHide(_ notification: NSNotification) {
        
        UIView.animate(withDuration: 0.2) {
            self.doneButton.snp.remakeConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(20)
                $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
                $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(20)
                $0.height.equalTo(56)
            }
            
            self.doneButton.superview?.layoutIfNeeded()
        }
    }
    
    func configureLayout() {
        self.view.addSubview(currentLabel)
        self.view.addSubview(textField)
        self.view.addSubview(doneButton)
        
        self.view.endEditing(true)
        
        textField.delegate = self
        currentLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(currentLabel.snp.bottom).offset(16)
            $0.leading.equalTo(currentLabel)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
        
    }
}

extension FirstTypingViewController: UITextFieldDelegate {
     
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text ?? "" != "" {
            self.doneButton.alpha = 1.0
        } else {
            self.doneButton.alpha = 0.0001
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}
