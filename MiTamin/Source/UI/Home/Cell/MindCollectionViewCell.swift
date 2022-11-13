//
//  MindCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/08.
//

import UIKit
import SwiftUI
import SnapKit
import Combine

class MindSelectViewModel: ObservableObject {
    //var selectIndex = CurrentValueSubject<Int, Never>(UserDefaults.standard.integer(forKey: .mindSelectIndex))
    @Published var index: Int = 0
    @Published var mindButtonImage: [String] = [
        "VBad", "Bad", "Soso","Good","VGood"
    ]
    @Published var mindDescription: [String] = [
        "매우 나빠요","나쁜 편이에요","그럭저럭이에요","좋은 편이에요","매우 좋아요!"
    ]
}

class MindCollectionViewCell: UICollectionViewCell {
    
    var viewModel: MindSelectViewModel?
    
    static let cellId: String = "MindCollectionViewCell"
    
    weak var delegate: MyTaminCollectionViewDelegate?
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "3. 하루 진단하기"
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.grayColor4
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 마음 컨디션은 어떤가요?"
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.SDGothicMedium(size: 18)
        label.textColor = UIColor.grayColor3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        
        let mindView = UIHostingController(rootView: MindSelectView(viewModel: self.viewModel ?? MindSelectViewModel()))
        
       // let mainSubTitleView = UIHostingController(rootView: MainSubTitleView(mainTitle: "3. 하루 진단하기",
                                                                             // subTitle: "오늘의 마음 컨디션은 어떤가요?"))
        mindView.rootView.buttonClickIndex = { [weak self] idx in
            guard let self = self else { return }
            self.delegate?.buttonClick(idx: idx)
        }
        addSubview(mindView.view)
        
        addSubview(mainLabel)
        addSubview(subLabel)
        
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom)
            $0.leading.equalTo(mainLabel.snp.leading)
        }
        
        mindView.view.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        
        
    }
    
    
}
