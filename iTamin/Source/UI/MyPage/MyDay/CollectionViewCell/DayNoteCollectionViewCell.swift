//
//  DayNoteCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import UIKit
import SnapKit

class DayNoteCollectionViewCell: UICollectionViewCell {
    static let cellId = "DayNoteCollectionViewCell"
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    private let dayNoteMainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 마이데이에는\n어떤 추억을 쌓게 될까요?"
        label.textAlignment = .left
        label.font = UIFont.SDGothicBold(size: 24)
        label.numberOfLines = 0
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    private let mainillustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Mainillustration")
        
        return imageView
    }()
    
    private let notWriteMainLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 작성된\n마이데이 노트가 없어요."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    private let notWriteSubLabel: UILabel = {
        let label = UILabel()
        label.text = "마이데이를 기록해주세요!"
        label.numberOfLines = 0
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor3
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(dayNoteMainTitleLabel)
        scrollView.addSubview(mainillustrationImageView)
        scrollView.addSubview(notWriteMainLabel)
        scrollView.addSubview(notWriteSubLabel)
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        dayNoteMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(40)
            $0.leading.equalTo(scrollView.snp.leading).offset(20)
        }
        
        mainillustrationImageView.snp.makeConstraints {
            $0.top.equalTo(dayNoteMainTitleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
        
        notWriteMainLabel.snp.makeConstraints {
            $0.top.equalTo(mainillustrationImageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        notWriteSubLabel.snp.makeConstraints {
            $0.top.equalTo(notWriteMainLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(scrollView.snp.bottom).inset(20)
        }
    }
    
}
