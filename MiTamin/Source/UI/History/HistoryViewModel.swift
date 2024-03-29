//
//  HistoryViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import SwiftUI
import Combine

extension HistoryViewController {
    class ViewModel: ObservableObject {
        
        @Published var randomCareData: RandomCareModel? = nil
        @Published var feelingRankList: [FeelingRankModel] = []
        @Published var weeklyMentalList: [WeeklyMentalModel] = []
        @Published var currentDate = Date()
        @Published var calendarMonthList: [CalendarModel] = []
        @Published var calendarWeekList: [WeeklyCalendarModel] = []
        @Published var selectWeeklyDate: String = ""
        @Published var selectDate: String = ""
        @Published var dataIsReady: Bool = false
        @Published var calendarLoading: Bool = false
        var buttonClick = PassthroughSubject<Int, Never>()
        @Published var weeklyCalendarData: WeeklyCalendarModel? = nil
        var cancelBag = CancelBag()
        
        var networkManager = NetworkManager()
        
        func deleteMyTamin(id: Int) {
            networkManager.deleteMyTamin(id: id)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.getCalendarWeekly(date: self.selectDate)
                    let replace = self.selectDate.components(separatedBy: ".")
                    self.getCalendarMonthly(date: "\(replace[0]).\(replace[1])")
                })
                .cancel(with: cancelBag)
        }
        
        func getCalendarWeekly(date: String) {
            withAnimation {
                dataIsReady = false
            }
            calendarWeekList.removeAll()
            self.weeklyCalendarData = nil
            
            networkManager.getCalendarWeekly(date: date)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    var calendarWeekList: [WeeklyCalendarModel] = []
                    value.data.forEach { (key, value) in
                        calendarWeekList.append(WeeklyCalendarModel(day: key, data: value))
                    }
                    self.calendarWeekList = calendarWeekList
                    
                    if let index = self.calendarWeekList.firstIndex(where: { Int($0.day) == Int(self.selectWeeklyDate) }) {
                        print("들어옴,",self.calendarWeekList[index])
                        self.weeklyCalendarData = self.calendarWeekList[index]
                    } else {
                        print("못들어옴..")
                    }
                    
                    withAnimation {
                        self.dataIsReady = true
                    }
                    
                })
                .cancel(with: cancelBag)
        }
        
        func getCalendarMonthly(date: String) {
            withAnimation {
                self.calendarLoading = true
            }
            self.calendarMonthList.removeAll()
            networkManager.getCalendarMonthly(day: date)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                    withAnimation {
                        self.calendarLoading = false
                    }
                }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.calendarMonthList = value.data
                    
                    withAnimation {
                        self.calendarLoading = false
                    }
                })
                .cancel(with: cancelBag)
        }
        
        func getWeeklyMental() {
            networkManager.getWeekMental()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.weeklyMentalList = value.data
                })
                .cancel(with: cancelBag)
        }
        
        func getFeelingRank() {
            networkManager.getFeelingRank()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("Finish")
                    }
                }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.feelingRankList = value.data
                })
                .cancel(with: cancelBag)
        }
        
        func getCareRandomData() {
            networkManager.getCareRandom()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    if let value = value.data {
                        self.randomCareData = value
                    } else {
                        self.randomCareData = nil
                    }
                })
                .cancel(with: cancelBag)
        }
    }
}
