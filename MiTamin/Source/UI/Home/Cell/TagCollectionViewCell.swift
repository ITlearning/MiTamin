//
//  TagCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/08.
//

import UIKit
import SnapKit

class TagCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "TagCollectionViewCell"
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicMedium(size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(8)
            $0.bottom.equalTo(self.snp.bottom).inset(8)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(16)
        }
    }
    
    func setCellText(text: String) {
        tagLabel.text = text
        tagLabel.sizeToFit()
    }
    
    func selectAction() {
        self.backgroundColor = UIColor.primaryColor
        self.layer.cornerRadius = 17
        self.layer.borderWidth = 0
        tagLabel.textColor = UIColor.white
    }
    
    func deselectAction() {
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.grayColor1.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 17
        tagLabel.textColor = UIColor.grayColor1
    }
}
