//
//  UIVIew.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import UIKit


extension UIView {
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
