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
    
    let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        
        return v
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicRegular(size: 14)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.numberOfLines = 0
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
        v.layer.masksToBounds = true
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
        self.addSubview(containerView)
        
        containerView.addSubview(backGroundView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(spacerView)
        spacerView.backgroundColor = .clear
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        backGroundView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.bottom.equalTo(spacerView.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backGroundView.snp.top).offset(16)
            $0.leading.equalTo(backGroundView.snp.leading).offset(16)
            $0.trailing.equalTo(backGroundView.snp.trailing).inset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        spacerView.snp.makeConstraints {
            $0.top.equalTo(backGroundView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.bottom)
            $0.height.equalTo(12)
        }
    }
    
}
