//
//  CutsomTextField.swift
//  iTamin
//
//  Created by Tabber on 2022/09/23.
//

import UIKit
import SnapKit

class CustomTextField: UITextField {
    
    let underLine = UIView()
    
    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 5)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        underLine.backgroundColor = UIColor.underLineGray
        
        self.addSubview(underLine)
        
        underLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        setFont()
    }
    
    func setFont() {
        font = UIFont.notoRegular(size: 13)
    }
}


class CustomTextField3: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CustomTextField2: UITextField {
    
    let underLine = UIView()
    
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clearButtonMode = .always
        backgroundColor = .backGroundWhiteColor
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        underLine.backgroundColor = UIColor.backGroundWhiteColor
        
        underLine.layer.cornerRadius = 12
        
  //      self.addSubview(underLine)
        clearButtonMode = .always
        
        backgroundColor = .backGroundWhiteColor
        layer.cornerRadius = 12
        
        
//        underLine.isUserInteractionEnabled = false
//
//        underLine.snp.makeConstraints {
//            $0.bottom.equalToSuperview()
//            $0.leading.equalToSuperview()
//            $0.trailing.equalToSuperview()
//            $0.height.equalTo(50)
//        }
        
        setFont()
    }
    
    func setFont() {
        font = UIFont.notoRegular(size: 13)
        textColor = .grayColor4
    }
}
