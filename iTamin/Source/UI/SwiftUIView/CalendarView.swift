//
//  CalendarView.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import SwiftUI
import DateGrid

struct CalendarView: View {
    @State var selectedMonthDate = Date()
    @StateObject var viewModel: HistoryViewController.ViewModel
    @State var calendarMonthList: [CalendarModel] = []
    
    func getConditionNum(date: String) -> Int {
        if let index = calendarMonthList.firstIndex(where: { $0.day == Int(date) }) {
            return calendarMonthList[index].mentalConditionCode
        } else {
            return 0
        }
    }
    
    var body: some View {
        DateGrid(interval: .init(start: selectedMonthDate, end: selectedMonthDate), selectedMonth: $selectedMonthDate, mode: .month(estimateHeight: 400)) { dateGridDate in
            
            VStack(spacing: 4) {
                Text(dateGridDate.date.day)
                    .font(.SDGothicMedium(size: 14))
                    .foregroundColor( getConditionNum(date: dateGridDate.date.day) != 0 ? Color.black : Color(uiColor: .grayColor7 ))
                
                switch getConditionNum(date: dateGridDate.date.day) {
                case 1:
                    Image("BVBadCalendar")
                        .resizable()
                        .frame(width: 24, height: 24)
                case 2:
                    Image("BBadCalendar")
                        .resizable()
                        .frame(width: 24, height: 24)
                case 3:
                    Image("BSoSoCalendar")
                        .resizable()
                        .frame(width: 24, height: 24)
                case 4:
                    Image("BGoodCalendar")
                        .resizable()
                        .frame(width: 24, height: 24)
                case 5:
                    Image("VGCircle")
                        .resizable()
                        .frame(width: 24, height: 24)
                default:
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.bottom, 20)
            
        }
        .onReceive(viewModel.$currentDate, perform: { value in
            selectedMonthDate = value
        })
        .onReceive(viewModel.$calendarMonthList, perform: { value in
            withAnimation {
                self.calendarMonthList = value
            }
        })
    }
}
