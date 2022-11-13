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
    @Published var mainTextViewString: String = ""
    @Published var subTextViewString: String = ""
}

class CategoryCollectionViewCell: UICollectionViewCell {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInset = UIEdgeInsets(
                    top: 0.0,
                    left: 0.0,
                    bottom: keyboardSize.size.height,
                    right: 0.0)
                scrollView.contentInset = contentInset
                scrollView.scrollIndicatorInsets = contentInset
            
            
            scrollView.scrollRectToVisible(textView.frame, animated: true)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellLayout() {
        
        let categoryView = UIHostingController(rootView: CategoryPickerView(viewModel: self.viewModel ?? CategoryCollectionViewModel()))
        let mainSubTitleView = UIHostingController(rootView: MainSubTitleView(mainTitle: "4. 칭찬 처방하기",
                                                                              subTitle: "어떤 부분을 칭찬해볼까요?"))
        
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(mainSubTitleView.view)
        containerView.addSubview(categoryView.view)
        containerView.addSubview(textView)
        containerView.addSubview(subLabel)
        containerView.addSubview(subTextView)
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
        
        mainSubTitleView.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        categoryView.view.snp.makeConstraints {
            $0.top.equalTo(mainSubTitleView.view.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width-40)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(categoryView.view.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
            $0.width.equalTo(UIScreen.main.bounds.width-40)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        subTextView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
            $0.bottom.equalTo(containerView.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width-40)
        }
        
        categoryView.rootView.onTap = {
            self.tapCategory?()
        }
        
    }
}
