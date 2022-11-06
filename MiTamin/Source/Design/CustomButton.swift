//
//  CustomButton.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import UIKit

class CustomButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setButton()
    }

    func setButton() {
        backgroundColor = UIColor.loginButtonGray
        layer.cornerRadius = 8
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.notoMedium(size: 18)
        clipsToBounds = true
    }
}
