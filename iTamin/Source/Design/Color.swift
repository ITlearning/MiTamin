//
//  Color.swift
//  iTamin
//
//  Created by Tabber on 2022/09/21.
//

import UIKit
import SwiftUI

extension UIColor {
    // MARK: - Global Color
    static let backButtonBlack = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
    static let progressGray = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
    // MARK: - Login
    static let loginButtonGray = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
    static let underLineGray = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
    static let buttonDone = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
    static let goodNickGray = UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.00)
    static let onboadingSubTitleGray = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1.00)
    static let nextTimeGray = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.00)
    // MARK: - Home
    static let tabBarUnSelectColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
    static let tabBarSelectColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
    static let mainTitleColor = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
    /// 0xFF7F57
    static let primaryColor = UIColor(rgb: 0xFF7F57)
    /// 0xFFF3AB
    static let mainTopYellowColor = UIColor(rgb: 0xFFF3AB)
    /// 0xF2F4F6
    static let backGroundWhiteColor = UIColor(rgb: 0xF2F4F6)
    /// 0xEDEDED
    static let tabBarShadow = UIColor(rgb: 0xEDEDED)
    // MARK: - TabBar
    static let selectTabBarColor = UIColor(rgb: 0xFF7F57)
    
    // MARK: - Sub Color
    /// 0xFFEB85
    static let subYellowColor = UIColor(rgb: 0xFFEB85)
    /// 0x1BD689
    static let subGreenColor = UIColor(rgb: 0x1BD689)
    /// 0x3FA3FF
    static let subBlueColor = UIColor(rgb: 0x3FA3FF)
    /// 0x7082FF
    static let subPurpleColor = UIColor(rgb: 0x7082FF)
    
    // MARK: - Background Color
    /// 0xF2F4F6
    static let backgroundColor2 = UIColor(rgb: 0xF2F4F6)
    /// 0xFFF3AB
    static let backgroundColor3 = UIColor(rgb: 0xFFF3AB)
    
    
    // MARK: - Gray Color
    /// 0xDDDDDD
    static let grayColor1 = UIColor(rgb: 0xDDDDDD)
    /// 0x999999
    static let grayColor2 = UIColor(rgb: 0x999999)
    /// 0x666666
    static let grayColor3 = UIColor(rgb: 0x666666)
    /// 0x121212
    static let grayColor4 = UIColor(rgb: 0x121212)
    /// 0xDBDBDB
    static let grayColor5 = UIColor(rgb: 0xDBDBDB)
    /// 0xD8D8D8
    static let grayColor6 = UIColor(rgb: 0xD8D8D8)
    /// 0xCCCCCC
    static let grayColor7 = UIColor(rgb: 0xCCCCCC)
    /// 0x817979
    static let grayColor8 = UIColor(rgb: 0x817979)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
