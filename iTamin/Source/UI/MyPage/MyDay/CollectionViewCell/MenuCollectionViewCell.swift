//
//  MenuCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/24.
//

import UIKit
import SnapKit

class MenuCollectionViewCell: UICollectionViewCell {
    static let cellId = "MenuCollectionViewCell"
    
    var tabLabel: UILabel = {
        let label = UILabel()
        label.text = "위시리스트"
        label.textAlignment = .center
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = UIColor.grayColor7
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            self.tabLabel.textColor = isSelected ? .grayColor4 : .grayColor7
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(tabLabel)
        
        tabLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
