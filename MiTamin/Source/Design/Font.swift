//
//  Font.swift
//  iTamin
//
//  Created by Tabber on 2022/09/22.
//

import UIKit
import SwiftUI

extension UIFont {
    static func notoBlack(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "NotoSansKR-Black", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func notoBold(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "NotoSansKR-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func notoLight(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "NotoSansKR-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func notoMedium(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "NotoSansKR-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func notoRegular(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "NotoSansKR-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func notoThin(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "NotoSansKR-Thin", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func SDGothicBold(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func SDGothicMedium(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func SDGothicRegular(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

extension Font {
    static func SDGothicBold(size: CGFloat = 14) -> Font {
        return Font.custom("AppleSDGothicNeo-Bold", size: size)
    }
    static func SDGothicMedium(size: CGFloat = 14) -> Font {
        return Font.custom("AppleSDGothicNeo-Medium", size: size)
    }
    static func SDGothicRegular(size: CGFloat = 14) -> Font {
        return Font.custom("AppleSDGothicNeo-Regular", size: size)
    }
}


extension UILabel {
    func addCharacterSpacing(_ value: Double = -0.03) {
        let kernValue = self.font.pointSize * CGFloat(value)
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}
