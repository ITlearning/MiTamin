//
//  CalendarView.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import SwiftUI
import DateGrid

protocol CalendarDelegate: AnyObject {
    func calendarTap(date: String)
}

enum CalendarType {
    case month
    case week
}
 
struct CalendarView: View {
    @State var selectedMonthDate = Date()
    @StateObject var viewModel: HistoryViewController.ViewModel
    @State var calendarMonthList: [CalendarModel] = []
    @State var selectDate: String = ""
    var type: CalendarType = .month
    
    weak var delegate: CalendarDelegate?
    
    func getConditionNum(date: String) -> Int {
        if let index = calendarMonthList.firstIndex(where: { $0.day == Int(date) }) {
            return calendarMonthList[index].mentalConditionCode
        } else {
            return 0
        }
    }
    
    var body: some View {
        
        if type == .month {
            DateGrid(interval: .init(start: selectedMonthDate, end: selectedMonthDate), selectedMonth: $selectedMonthDate, mode: type == .month ? .month(estimateHeight: 400) : .week(estimateHeight: 200)) { dateGridDate in
                
                calendarCell(day: dateGridDate.date.day)
                .padding(.bottom, 20)
                .onTapGesture {
                    delegate?.calendarTap(date: Date.dateToString(date: viewModel.currentDate)+".\(dateGridDate.date.day)")
                }
                
            }
            .onReceive(viewModel.$currentDate, perform: { value in
                selectedMonthDate = value
            })
            .onReceive(viewModel.$calendarMonthList, perform: { value in
                withAnimation {
                    self.calendarMonthList = value
                }
            })
        } else {
            ScrollViewReader { reader in
                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack(spacing: 8) {
                        ForEach(calendarMonthList, id:\.self) { item in
                            calendarCell(day: String(item.day), type: .week)
                                .onTapGesture {
                                    if item.day < 10 {
                                        delegate?.calendarTap(date: Date.dateToString(date: viewModel.currentDate)+".0\(item.day)")
                                    } else {
                                        delegate?.calendarTap(date: Date.dateToString(date: viewModel.currentDate)+".\(item.day)")
                                    }
                                    
                                }
                                .id(item.day)
                        }
                    }
                })
                .onReceive(viewModel.$currentDate, perform: { value in
                    selectedMonthDate = value
                })
                .onReceive(viewModel.$calendarMonthList, perform: { value in
                    withAnimation {
                        self.calendarMonthList = value
                    }
                })
                .onReceive(viewModel.$selectWeeklyDate, perform: { value in
                    let date = Int(value) ?? 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        withAnimation {
                            reader.scrollTo(date, anchor: .center)
                        }
                    })
                    self.selectDate = "\(date)"
                })
                .onReceive(viewModel.$calendarWeekList, perform: { value in
                    print(value)
                })
            }
            

            
        }
        
    }
    
    func calendarCell(day: String, type: CalendarType = .month) -> some View {
        VStack(spacing: 4) {
            
            if type == .month {
                Text(day)
                    .font(.SDGothicMedium(size: 14))
                    .foregroundColor( getConditionNum(date: day) != 0 ? Color.black : Color(uiColor: .grayColor7 ))
            } else {
                Text(day)
                    .font(selectDate == day ? .SDGothicBold(size: 14) : .SDGothicMedium(size: 14))
                    .foregroundColor( getConditionNum(date: day) != 0 ? selectDate == day ? Color.white : Color.black : Color(uiColor: .grayColor7 ))
                    .padding()
                    .background(
                        Circle()
                            .frame(width: 22, height: 22, alignment: .center)
                            .foregroundColor(Color(uiColor: .primaryColor))
                            .opacity(selectDate == day ? 1 : 0)
                            .offset(x: 0, y: -1)
                    )
            }
            
            
            
            switch getConditionNum(date: day) {
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
    }
}
