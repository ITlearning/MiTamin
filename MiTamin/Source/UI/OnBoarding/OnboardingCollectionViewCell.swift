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
    private var cancelBag = CancelBag()
    
    var pickDate: (([String]) -> ())?
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.grayColor4
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
        label.font = UIFont.SDGothicRegular(size: 16)
        label.textColor = UIColor.grayColor2
        label.isHidden = true
        return label
    }()
    
    let datePicker: CustomDatePicker = {
        let picker = CustomDatePicker()
        picker.isHidden = true
        return picker
    }()
    
    var formatter = DateFormatter()
    var dateResult: String = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        bindCombine()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(mainTitle: String, image: String) {
        descriptionLabel.text = mainTitle
        illustrationImageView.image = UIImage(named: image)
    }
    
    
    func bindCombine() {
        datePicker.datePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { date in
                print(date)
                self.formatter.locale = Locale(identifier: "ko_KR")
                self.formatter.setLocalizedDateFormatFromTemplate("HH:mm")
                self.dateResult = self.formatter.string(from: date)
                let split = self.dateResult.components(separatedBy: ":")
                
                self.pickDate?(split)
                
            })
            .cancel(with: cancelBag)
    }
    
    private func configureLayout() {
        self.addSubview(baseView)
        baseView.addSubview(descriptionLabel)
        //baseView.addSubview(illustrationImageView)
        baseView.addSubview(subDescriptionLabel)
        baseView.addSubview(datePicker)
        
        baseView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(5)
            $0.leading.equalTo(self.snp.leading).offset(37)
        }
        
        subDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(9)
            $0.leading.equalTo(descriptionLabel.snp.leading)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(subDescriptionLabel.snp.bottom).offset(55)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
        }
        
    }
    
    func setHidden(hidden: Bool = true) {
        subDescriptionLabel.isHidden = hidden
        datePicker.isHidden = hidden
        illustrationImageView.isHidden = !hidden
    }
}
