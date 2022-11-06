//
//  TextViewCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/09.
//

import UIKit
import SnapKit
import SwiftUI

class TextViewCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "TextViewCollectionViewCellId"
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "오늘 아침의 나에게 하루를 진단해준다면?"
        tv.font = UIFont.SDGothicRegular(size: 14)
        tv.textColor = UIColor.grayColor2
        tv.layer.cornerRadius = 8
        tv.layer.borderColor = UIColor.grayColor5.cgColor
        tv.layer.borderWidth = 1
        tv.layer.masksToBounds = true
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellLayout() {
        
        let mainSubTitleView = UIHostingController(rootView: MainSubTitleView(mainTitle: "3. 하루 진단하기",
                                                                              subTitle: "오늘 하루를 진단해주세요."))
        
        addSubview(mainSubTitleView.view)
        addSubview(textView)
        mainSubTitleView.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(mainSubTitleView.view.snp.bottom).offset(20)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(180)
        }
    }
}
