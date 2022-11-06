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
        @Published var dataIsReady: Bool = true
        var cancelBag = CancelBag()
        
        var networkManager = NetworkManager()
        
        func getCalendarWeekly(date: String) {
            networkManager.getCalendarWeekly(date: date)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    var calendarWeekList: [WeeklyCalendarModel] = []
                    value.data.forEach { (key, value) in
                        calendarWeekList.append(WeeklyCalendarModel(day: key, data: value))
                    }
                    self.calendarWeekList = calendarWeekList
                    
                })
                .cancel(with: cancelBag)
        }
        
        func getCalendarMonthly(date: String) {
            networkManager.getCalendarMonthly(day: date)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.calendarMonthList = value.data
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
