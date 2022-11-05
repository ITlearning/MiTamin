//
//  CareHistoryTableViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import UIKit
import SnapKit

class CareHistoryTableViewCell: UITableViewCell {

    static let cellId = "careHistoryTableViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicRegular(size: 14)
        label.textAlignment = .left
        label.textColor = UIColor.black
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor2
        label.font = UIFont.SDGothicRegular(size: 12)
        
        return label
    }()
    
    let backGroundView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(rgb: 0xFBF9F7)
        v.layer.cornerRadius = 12
        return v
    }()
    
    let spacerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(title: String, date: String) {
        self.titleLabel.text = title
        self.dateLabel.text = date
    }
    
    private func configureCell() {
        self.addSubview(backGroundView)
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
        self.addSubview(spacerView)
        
        backGroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(spacerView.snp.top)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(16)
            $0.leading.equalTo(self.snp.leading).offset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top).offset(16)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        spacerView.snp.makeConstraints {
            $0.top.equalTo(backGroundView.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(12)
        }
    }
    
}
