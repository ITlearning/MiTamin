//
//  DayNoteHeaderCollectionReusableView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/31.
//

import UIKit

class DayNoteHeaderCollectionReusableView: UICollectionReusableView {
    static let cellId = "DayNoteHeaderCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "2022년"
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicMedium(size: 18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHeader(title: String) {
        label.text = title
    }
    
    
    func configureLayout() {
        self.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
        }
    }
}
