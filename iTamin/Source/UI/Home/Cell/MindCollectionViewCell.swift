//
//  MindCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/08.
//

import UIKit
import SwiftUI
import SnapKit

class MindCollectionViewCell: UICollectionViewCell {
    
    static let cellId: String = "MindCollectionViewCell"
    
    var buttonClick: ((Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureCell() {
        let mindView = UIHostingController(rootView: MindSelectView())
        
        mindView.rootView.buttonClickIndex = { idx in
            print(idx)
            self.buttonClick?(idx)
        }
        
        addSubview(mindView.view)
        
        mindView.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    
}
