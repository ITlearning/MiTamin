//
//  DayNoteListCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/30.
//

import UIKit
import SnapKit
import Kingfisher

class DayNoteListCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "DayNoteListCollectionViewCell"
    
    private let gradientView: UIView = {
        let gView = UIView()
        gView.applyGradient(colours: [UIColor.grayColor4.withAlphaComponent(0.6), UIColor.clear])
        gView.blur(blurRadius: 5)
        gView.layer.cornerRadius = 8
        gView.backgroundColor = .clear
        gView.layer.masksToBounds = true
        return gView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.SDGothicBold(size: 18)
        label.text = "10월"
        label.isSkeletonable = true
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItem(month: String, image: String) {
        label.text = month
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: image)!)
    }
    
    func configureLayout() {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.grayColor4.withAlphaComponent(0.6).cgColor,UIColor.clear.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = bounds
        imageView.layer.addSublayer(gradient)
        
        self.addSubview(imageView)
        self.addSubview(label)
        self.addSubview(gradientView)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(104)
            $0.height.equalTo(104)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(12)
            $0.leading.equalTo(self.snp.leading).offset(12)
            $0.width.equalTo(self.snp.width)
            $0.height.equalTo(18)
        }
        
        gradientView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top)
            $0.leading.trailing.equalTo(imageView)
            $0.width.equalTo(imageView.snp.width)
            $0.height.equalTo(42)
        }
    }
    
}
