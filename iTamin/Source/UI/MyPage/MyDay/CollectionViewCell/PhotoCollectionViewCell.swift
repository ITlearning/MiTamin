//
//  PhotoCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "PhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    let button: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(named: "icon-x-circle-mono")
        button.isSkeletonable = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImage(image: UIImage) {
        imageView.image = image
    }
    
    func configureLayout() {
        self.addSubview(imageView)
        self.addSubview(button)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        button.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(12)
            $0.trailing.equalTo(self.snp.trailing).inset(12)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
    }
    
}
