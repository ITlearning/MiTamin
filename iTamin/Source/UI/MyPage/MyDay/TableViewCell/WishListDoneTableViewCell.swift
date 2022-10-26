//
//  WishListDoneTableViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/26.
//

import UIKit
import SnapKit

class WishListDoneTableViewCell: UITableViewCell {

    static let cellId = "WishListDoneTableViewCell"
    
    let wishListLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicBold(size: 16)
        label.textColor = UIColor.primaryColor
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(item: WishListModel) {
        self.wishListLabel.text = item.wishText
        self.countLabel.text = "\(item.count)회"
    }
    
    
    func configureCell() {
        self.backgroundColor = .white
        
        let borderView = UIView()
        
        borderView.layer.borderColor = UIColor.grayColor2.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 8
        borderView.backgroundColor = .clear
        
        let spacerView = UIView()
        self.addSubview(wishListLabel)
        self.addSubview(countLabel)
        self.addSubview(borderView)
        self.addSubview(spacerView)
        
        wishListLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(16)
            $0.leading.equalTo(self.snp.leading).offset(16)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(16)
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
