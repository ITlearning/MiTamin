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
        @Published var note: String = ""
        @Published var uploadSuccess: Bool = false
        var isDemmed = PassthroughSubject<Bool, Never>()
        var editModel: DayNoteModel? = nil
        var isEdit = false
        var isReady: Bool = false
        var selectYear: Int = 0
        var selectMonth: Int = 0
        var selectImages: [UIImage] = []
        var isWrite = CurrentValueSubject<Bool, Never>(false)
        var selectWishList: WishListModel? = nil
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        
        func loadWishList(idx: Int) {
            networkManager.getWishList()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    if let idx = value.data.firstIndex(where: { $0.wishId == idx }) {
                        self.selectWishList = value.data[idx]
                    }
                })
                .cancel(with: cancelBag)
        }
        
        func editDayNote() {
            if editModel != nil {
                
                networkManager.editDayNote(daynoteId: editModel?.daynoteId ?? 0, wishIdx: selectWishList?.wishId ?? 0, note: note, images: selectImages)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _
                        in
                    }, receiveValue: { [weak self] value in
                        guard let self = self else { return }
                        self.isDemmed.send(false)
                        self.uploadSuccess = true
                    })
                    .cancel(with: cancelBag)
            }
            
        }
        
        func writeDayNote() {
            networkManager.writeDayNote(wishIdx: selectWishList?.wishId ?? 0, note: note, date: currentDay, images: selectImages)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    print(value.data)
                    self?.isDemmed.send(false)
                    UserDefaults.standard.set(true, forKey: "MyDayUpdate")
                    self?.uploadSuccess = true
                })
                .cancel(with: cancelBag)
        }
        
        func checkMonth(value: String) {
            isDemmed.send(true)
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
                    if !self.isEdit {
                        self.firstDay = "\(String(value.data.year)).\(String(value.data.month))"
                        self.selectYear = value.data.year
                        self.selectMonth = value.data.month
                        self.currentDay = "\(String(value.data.year)).\(String(value.data.month))"
                        self.currentDayPrint = "\(String(value.data.year))년 \(String(value.data.month))월의 마이데이"
                    }
                    
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
