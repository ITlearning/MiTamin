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
    
    let roundedView = UIHostingController(rootView: RoundedCircleView(radius: 60, width: 218, height: 218))
    
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
        
        containerView.addSubview(roundedView.view)
        roundedView.view.addSubview(mainImageView)
        containerView.addSubview(timerLabel)
        containerView.addSubview(playButton)
        containerView.addSubview(mainTitle)
        containerView.addSubview(subTitle)
        roundedView.view.layer.cornerRadius = 60
        roundedView.view.clipsToBounds = true
        
        let shadowView = UIView()
        shadowView.backgroundColor = .clear
        roundedView.view.addSubview(shadowView)
        
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        roundedView.view.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(30)
            $0.centerX.equalTo(containerView.snp.centerX)
        }
        
        shadowView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(roundedView.view)
        }
    
        mainImageView.snp.makeConstraints {
            $0.bottom.equalTo(roundedView.view.snp.bottom).offset(53)
            $0.trailing.equalTo(roundedView.view.snp.trailing).inset(10)
            $0.width.equalTo(241)
            $0.height.equalTo(203)
        }
     
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(roundedView.view.snp.top).offset(40)
            $0.centerX.equalTo(containerView.snp.centerX)
        }
        
        playButton.snp.makeConstraints {
            $0.top.equalTo(roundedView.view.snp.bottom).offset(24)
            $0.centerX.equalTo(roundedView.view.snp.centerX)
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
        mainImageView.image = UIImage(named: image)
        
        if index != 0 {
            mainImageView.snp.remakeConstraints {
                $0.bottom.equalTo(roundedView.view.snp.bottom).offset(80)
                $0.trailing.equalTo(roundedView.view.snp.trailing).inset(2.5)
                $0.leading.equalTo(roundedView.view.snp.leading).offset(3.5)
                $0.width.equalTo(212)
                $0.height.equalTo(212)
            }
        } else {
            mainImageView.snp.remakeConstraints {
                $0.bottom.equalTo(roundedView.view.snp.bottom).offset(53)
                $0.trailing.equalTo(roundedView.view.snp.trailing).inset(10)
                $0.width.equalTo(241)
                $0.height.equalTo(203)
            }
        }
        
        self.mainTitle.text = mainTitle
        self.subTitle.text = subTitle
    }
}
