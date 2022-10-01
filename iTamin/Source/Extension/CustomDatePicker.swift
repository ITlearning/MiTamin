//
//  CustomDatePicker.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import UIKit

class CustomDatePicker: UIDatePicker {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setConfigure()
    }
    
    func setConfigure() {
        preferredDatePickerStyle = .wheels
        datePickerMode = .time
        locale = Locale(identifier: "ko-KR")
        minuteInterval = 5
    }

}
