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
