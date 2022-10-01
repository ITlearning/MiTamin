//
//  MyTaminCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/09/29.
//

import UIKit
import SwiftUI
import SnapKit
import Combine
import CombineCocoa


class MyTaminCollectionViewCell: UICollectionViewCell {
    static let cellId = "MyTaminCollectionViewCell"
    
    let containerView: UIView = {
        let containView = UIView()
        containView.backgroundColor = .clear
        
        return containView
    }()
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myTaminTimerImage")
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    
    let timer = Timer()
    
    var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.SDGothicBold(size: 40)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PlayButton"), for: .normal)
        
        return button
    }()
    
    let mainTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicRegular(size: 14)
        label.textColor = UIColor.grayColor3
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let timerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myTaminTimerImage")
        
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCellLayout() {
        addSubview(containerView)
        
        containerView.addSubview(timerImageView)
        containerView.addSubview(timerLabel)
        containerView.addSubview(playButton)
        containerView.addSubview(mainTitle)
        containerView.addSubview(subTitle)
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        timerImageView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(30)
            $0.centerX.equalTo(containerView.snp.centerX)
            $0.width.equalTo(218)
            $0.height.equalTo(218)
        }
     
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(timerImageView.snp.top).offset(40)
            $0.centerX.equalTo(containerView.snp.centerX)
        }
        
        playButton.snp.makeConstraints {
            $0.top.equalTo(timerImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(timerImageView.snp.centerX)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(playButton.snp.bottom).offset(40)
            $0.centerX.equalTo(containerView.snp.centerX)
        }

        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(20)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(21)
        }
        
    }
    
    func configureCell(index: Int, image: String, mainTitle: String, subTitle: String) {
        timerImageView.image = UIImage(named: image)
        
        self.mainTitle.text = "\(index+1). "+mainTitle
        self.subTitle.text = subTitle
    }
}
