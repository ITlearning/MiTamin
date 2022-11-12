//
//  WishListTableViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/25.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

protocol WishListDelegate: AnyObject {
    func textFieldDone(text: String)
    func textFieldEdit(item: WishListModel)
}

class WishListTypingTableViewCell: UITableViewCell {

    static let cellId = "WishListTableViewCell"
    
    var cancelBag = CancelBag()
    
    weak var delegate: WishListDelegate?
    
    var editModel: Bool = false
    
    let borderView = UIView()
    
    let wishListTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "내용 입력"
        textField.font = UIFont.SDGothicMedium(size: 16)
        textField.textColor = UIColor.grayColor4
        textField.borderStyle = .none
        return textField
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "WishAddButton"), for: .normal)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        bindCombine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindCombine() {
        addButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                self?.delegate?.textFieldDone(text: self?.wishListTextField.text ?? "")
                self?.wishListTextField.text = ""
                self?.endEditing(true)
            })
            .cancel(with: cancelBag)
    }
    
    func setMode() {
        if editModel {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
        
        contentView.addSubview(addButton)
        
        let minusValue: CGFloat = editModel ? 20 : (48 + 20 + 16 + 12)
        
        wishListTextField.snp.remakeConstraints {
            $0.top.equalTo(self.snp.top).offset(16)
            $0.leading.equalTo(self.snp.leading).offset(16)
            $0.width.equalTo(UIScreen.main.bounds.width - minusValue)
        }
        
        if editModel {
            borderView.snp.remakeConstraints {
                $0.top.equalTo(self.snp.top)
                $0.leading.equalTo(self.snp.leading)
                $0.trailing.equalTo(self.snp.trailing)
                $0.width.equalTo(UIScreen.main.bounds.width - minusValue)
                $0.height.equalTo(48)
            }
        } else {
            borderView.snp.remakeConstraints {
                $0.top.equalTo(self.snp.top)
                $0.leading.equalTo(self.snp.leading)
                $0.width.equalTo(UIScreen.main.bounds.width - minusValue)
                $0.height.equalTo(48)
            }
        }
 
    }
    
    func configureCell() {
        self.backgroundColor = .white
        

        
        borderView.layer.borderColor = UIColor.grayColor5.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 8
        borderView.backgroundColor = .clear
        
        let spacerView = UIView()
        self.addSubview(borderView)
        self.addSubview(spacerView)
        
        contentView.addSubview(wishListTextField)
        
        if editModel {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
        
        contentView.addSubview(addButton)
        
        let minusValue: CGFloat = editModel ? 20 : (48 - 20 - 16 - 12)
        
        wishListTextField.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(16)
            $0.leading.equalTo(self.snp.leading).offset(16)
            $0.width.equalTo(UIScreen.main.bounds.width - minusValue)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(48)
            $0.width.equalTo(48)
        }
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.width.equalTo(UIScreen.main.bounds.width - minusValue)
            $0.height.equalTo(48)
        }
        
        spacerView.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

