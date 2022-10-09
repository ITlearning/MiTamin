//
//  CategoryCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/09.
//

import UIKit
import SwiftUI
import SnapKit


class CategoryCollectionViewModel: ObservableObject {
    @Published var text: String = "카테고리를 골라주세요."
}

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "CategoryCollectionViewCell"
    
    var viewModel: CategoryCollectionViewModel?
    
    var tapCategory: (() -> ())?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "스스로를 칭찬해주세요!"
        tv.font = UIFont.SDGothicRegular(size: 14)
        tv.textColor = UIColor.grayColor2
        tv.layer.cornerRadius = 8
        tv.layer.borderColor = UIColor.grayColor5.cgColor
        tv.layer.borderWidth = 1
        tv.layer.masksToBounds = true
        return tv
    }()
    
    let subTextView: UITextView = {
        let tv = UITextView()
        tv.text = "대단해, 발전하고 있어, 역시 나야 등"
        tv.font = UIFont.SDGothicRegular(size: 14)
        tv.textColor = UIColor.grayColor2
        tv.layer.cornerRadius = 8
        tv.layer.borderColor = UIColor.grayColor5.cgColor
        tv.layer.borderWidth = 1
        tv.layer.masksToBounds = true
        return tv
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "칭찬의 문장으로 마무리해주세요."
        label.font = UIFont.SDGothicMedium(size: 18)
        label.textColor = UIColor.grayColor3
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellLayout() {
        
        let categoryView = UIHostingController(rootView: CategoryPickerView(viewModel: self.viewModel!))
        let mainSubTitleView = UIHostingController(rootView: MainSubTitleView(mainTitle: "4. 칭찬 처방하기",
                                                                              subTitle: "어떤 부분을 칭찬해볼까요?"))
        addSubview(mainSubTitleView.view)
        addSubview(categoryView.view)
        addSubview(textView)
        addSubview(subLabel)
        addSubview(subTextView)
        
        mainSubTitleView.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        categoryView.view.snp.makeConstraints {
            $0.top.equalTo(mainSubTitleView.view.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(categoryView.view.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(40)
            $0.leading.equalToSuperview()
        }
        
        subTextView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        categoryView.rootView.onTap = {
            self.tapCategory?()
        }
        
    }
}
