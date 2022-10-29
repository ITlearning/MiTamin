//
//  Date.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import Foundation

extension Date {
    static func stringToDate(year: String, month: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM"
        let date = dateFormatter.date(from: "\(year).\(month)")
        
        return date
    }
    
    static func addingDate(startDate: Date, addingMonth: Int) -> [String] {
        var dateComponents = DateComponents()
        dateComponents.month = addingMonth
        let resultDate = Calendar.current.date(byAdding: dateComponents, to: startDate)
        
        return dateToString(date: resultDate ?? Date())
        
    }
    
    static func dateToString(date: Date) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        let dateString = dateFormatter.string(from: date)
        
        let replace = dateString.components(separatedBy: ".")
        
        return replace
    }
    
    static func diffToMonth(day: Date) -> Int {
        let diff = Calendar.current.dateComponents([.month], from: day, to: Date())
        
        return diff.month ?? 0
    }
}
