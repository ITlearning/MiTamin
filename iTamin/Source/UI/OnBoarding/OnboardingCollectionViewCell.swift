//
//  OnboardingCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import UIKit
import SnapKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "OnboardingCell"
    
    private let baseView = UIView()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.notoMedium(size: 24)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        
        return label
    }()
    
    private let illustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let subDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "마이타민 섭취 알림을 보내드릴게요!"
        label.font = UIFont.notoRegular(size: 15)
        label.textColor = UIColor.onboadingSubTitleGray
        
        return label
    }()
    
    let datePicker: CustomDatePicker = {
        let picker = CustomDatePicker()
        
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(mainTitle: String, image: String) {
        descriptionLabel.text = mainTitle
        illustrationImageView.image = UIImage(named: image)
    }
    
    
    private func configureLayout() {
        self.addSubview(baseView)
        baseView.addSubview(descriptionLabel)
        baseView.addSubview(illustrationImageView)
        baseView.addSubview(subDescriptionLabel)
        baseView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(5)
            $0.leading.equalTo(self.snp.leading).offset(37)
        }
        
        illustrationImageView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom).inset(5)
            $0.trailing.equalTo(self.snp.trailing).inset(33)
            $0.width.equalTo(174)
            $0.height.equalTo(164)
        }
    }
}
