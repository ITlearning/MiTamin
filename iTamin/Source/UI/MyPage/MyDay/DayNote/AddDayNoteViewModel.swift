//
//  AddDayNoteViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import Foundation
import Combine
import UIKit

extension AddDayNoteViewController {
    class ViewModel: ObservableObject {
        
        @Published var days: [[String]] = [[]]
        @Published var currentDayPrint: String = ""
        @Published var currentDay: String = ""
        @Published var firstDay: String = ""
        
        var selectImages: [UIImage] = []
        var isWrite = CurrentValueSubject<Bool, Never>(false)
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        
        func checkMonth(value: String) {
            networkManager.checkDayNote(day: value)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    self.isWrite.send(value.data)
                })
                .cancel(with: cancelBag)
        }
        
        func loadDays() {
            days.removeAll()
            networkManager.getCreateAt()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    self.firstDay = "\(String(value.data.year)).\(String(value.data.month))"
                    self.currentDayPrint = "\(String(value.data.year))년 \(String(value.data.month))월의 마이데이"
                    let createdAt = Date.stringToDate(year: String(value.data.year), month: String(value.data.month))

                    let diffNum = Date.diffToMonth(day: createdAt ?? Date())
                    var Syear: [String] = []
                    var Smonth: [String] = []
                    for idx in 0...diffNum {
                        let date = Date.addingDate(startDate: createdAt ?? Date(), addingMonth: idx)
                        if !Syear.contains((date.first ?? "")) {
                            Syear.append((date.first ?? ""))
                        }
                        
                        if !Smonth.contains((date.last ?? "")) {
                            Smonth.append((date.last ?? ""))
                        }
                    }
                    
                    self.days.append(Syear)
                    self.days.append(Smonth)
                    
                    print(self.days)
                })
                .cancel(with: cancelBag)
        }
    }
}
