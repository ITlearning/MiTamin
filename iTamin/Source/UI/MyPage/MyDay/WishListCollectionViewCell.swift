//
//  WishListCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/24.
//

import UIKit
import SnapKit

class WishListCollectionViewCell: UICollectionViewCell {
    static let cellId = "WishListCollectionViewCell"
    
    private let wishListMainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "자신을 위해서 해보고\n싶은 행동이 있나요?"
        label.textAlignment = .left
        label.font = UIFont.SDGothicBold(size: 24)
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
        label.text = "아직 작성된\n위시리스트가 없어요."
        label.textAlignment = .center
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    private let notWriteSubLabel: UILabel = {
        let label = UILabel()
        label.text = "위시리스트를 채워주세요!"
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
    
    
    private func configureLayout() {
        self.addSubview(wishListMainTitleLabel)
        self.addSubview(mainillustrationImageView)
        self.addSubview(notWriteMainLabel)
        self.addSubview(notWriteSubLabel)
        
        wishListMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(40)
            $0.leading.equalTo(self.snp.leading).offset(20)
        }
        
        mainillustrationImageView.snp.makeConstraints {
            $0.top.equalTo(wishListMainTitleLabel.snp.bottom).offset(40)
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
        }
    }
    
}
