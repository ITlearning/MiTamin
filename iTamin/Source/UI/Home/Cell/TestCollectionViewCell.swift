//
//  TestCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/09/30.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    static let cellId = "TestCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .progressGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
