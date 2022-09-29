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
        label.font = UIFont.SDGothicMedium(size: 14)
        label.textColor = UIColor.grayColor3
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
        let roundedView = UIHostingController(rootView: RoundedCircleView(radius: 60, width: 218, height: 218))
        containerView.addSubview(roundedView.view)
        roundedView.view.addSubview(mainImageView)
        roundedView.view.addSubview(timerLabel)
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        roundedView.view.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(24)
            $0.centerX.equalTo(containerView.snp.centerX)
        }
        
        mainImageView.snp.makeConstraints {
            $0.bottom.equalTo(roundedView.view.snp.bottom).offset(53)
            $0.trailing.equalTo(roundedView.view.snp.trailing).inset(10)
            $0.width.equalTo(241)
            $0.height.equalTo(203)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(roundedView.view.snp.top).offset(40)
            $0.centerX.equalTo(roundedView.view.snp.centerX)
        }
        
        playButton.snp.makeConstraints {
            $0.top.equalTo(roundedView.view.snp.bottom).offset(24)
            $0.centerX.equalTo(containerView.snp.centerX)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(playButton.snp.bottom).offset(40)
            $0.centerX.equalTo(containerView.snp.centerX)
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(20)
            $0.centerX.equalTo(containerView.snp.centerX)
        }
        
    }
}
