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
    // MARK: - Home
    static let tabBarUnSelectColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
    static let tabBarSelectColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
    static let mainTitleColor = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
    
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
