//
//  WishListTableViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/25.
//

import UIKit
import SnapKit

protocol WishListDelegate: AnyObject {
    func textFieldDone(text: String)
    func textFieldEdit(item: WishListModel)
}

class WishListTypingTableViewCell: UITableViewCell {

    static let cellId = "WishListTableViewCell"
    
    let wishListTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "내용 입력"
        textField.font = UIFont.SDGothicMedium(size: 16)
        textField.textColor = UIColor.grayColor4
        textField.borderStyle = .none
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        self.backgroundColor = .white
        
        let borderView = UIView()
        
        borderView.layer.borderColor = UIColor.grayColor5.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 8
        borderView.backgroundColor = .clear
        
        let spacerView = UIView()
        self.addSubview(borderView)
        self.addSubview(spacerView)
        
        contentView.addSubview(wishListTextField)
        
        wishListTextField.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(16)
            $0.leading.equalTo(self.snp.leading).offset(16)
            $0.trailing.equalTo(self.snp.trailing).inset(16)
        }
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(48)
        }
        
        spacerView.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

