//
//  AddPhotoCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import UIKit
import SnapKit

class AddPhotoCollectionViewCell: UICollectionViewCell {
    static let cellId = "AddPhotoCollectionViewCell"
    
    let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AddButton"), for: .normal)
        button.isSkeletonable = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        self.contentView.addSubview(button)
        
        button.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
}
