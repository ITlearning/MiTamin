//
//  AddDayNoteViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import Foundation
import Combine

extension AddDayNoteViewController {
    class ViewModel: ObservableObject {
        
        @Published var days: [[String]] = [[]]
        @Published var currentDay: String = ""
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        func loadDays() {
            days.removeAll()
            networkManager.getCreateAt()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    
                    self.currentDay = "\(String(value.data.year))년 \(String(value.data.month))월의 마이데이"
                    let createdAt = Date.stringToDate(year: String(value.data.year), month: String(value.data.month))

                    let diffNum = Date.diffToMonth(day: createdAt ?? Date())
                    var Syear: [String] = []
                    var Smonth: [String] = []
                    for idx in 0...diffNum {
                        let date = Date.addingDate(startDate: createdAt ?? Date(), addingMonth: idx)
                        if !Syear.contains((date.first ?? "")+"년") {
                            Syear.append((date.first ?? "")+"년")
                        }
                        
                        if !Smonth.contains((date.last ?? "")+"월") {
                            Smonth.append((date.last ?? "")+"월")
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
