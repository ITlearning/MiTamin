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
    let spacerView = UIView()
    override func prepareForReuse() {
        super.prepareForReuse()
        wishListLabel.text = ""
        
    }
    
    let wishListLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor4
        label.isSkeletonable = true
        return label
    }()
    let borderView = UIView()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicBold(size: 16)
        label.textColor = UIColor.primaryColor
        label.isSkeletonable = true
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
    
    
    func selectAction() {
        borderView.layer.borderWidth = 0
        borderView.backgroundColor = .primaryColor
        wishListLabel.textColor = .white
        countLabel.textColor = .white
    }
    
    func deselectAction() {
        borderView.layer.borderWidth = 1
        borderView.backgroundColor = .clear
        wishListLabel.textColor = .grayColor4
        countLabel.textColor = .primaryColor
    }
    
    func configureCell() {
        self.backgroundColor = .white
        borderView.layer.borderColor = UIColor.grayColor5.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 8
        borderView.backgroundColor = .clear
        
        self.addSubview(borderView)
        contentView.addSubview(wishListLabel)
        contentView.addSubview(countLabel)
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
