//
//  MyTaminReportView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/09.
//

import SwiftUI

enum ReportType {
    case home
    case history
}

struct MyTaminReportView: View {
    
    @StateObject var viewModel: HomeViewController.ViewModel
    @StateObject var historyViewModel: HistoryViewController.ViewModel
    
    var type: ReportType = .home
    
    var notYetImageView: some View {
        VStack {
            Spacer()
            
            Image("MyTaminNotYet")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 26.5)
                .frame(height: 24)
            
            Spacer()
        }
        
    }
    
    var loadingView: some View {
        HStack {
            Text("열심히 로딩중이에요..!")
                .font(.SDGothicRegular(size: 15))
                .foregroundColor(Color(uiColor: UIColor.grayColor3))
                .padding(.leading, 30)
                .padding(.trailing, 25)
                .multilineTextAlignment(.leading)
        }
    }
    
    var feelingView: some View {
        HStack {
            Image(getImage(idx:( type == .home ? (viewModel.reportData?.mentalConditionCode ?? 0 ): historyViewModel.weeklyCalendarData?.data?.report?.mentalConditionCode ?? 0)))
                .resizable()
                .frame(width: 60, height: 60)
            ZStack {
                HStack(spacing: 0) {
                    Image("massageTail")
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 60)
                        .foregroundColor(Color(uiColor: UIColor.backGroundWhiteColor))
                }
                VStack(alignment: .leading) {
                    Text(type == .home ? viewModel.reportData?.feelingTag ?? "" : historyViewModel.weeklyCalendarData?.data?.report?.feelingTag ?? "")
                        .font(.SDGothicRegular(size: 12))
                        .foregroundColor(Color(uiColor: UIColor.grayColor3))
                        .padding(.leading, 30)
                        .padding(.trailing, 25)
                        .multilineTextAlignment(.leading)
                    Text("오늘은 기분이 \(type == .home ? viewModel.reportData?.mentalCondition ?? "" : historyViewModel.weeklyCalendarData?.data?.report?.mentalCondition ?? "")")
                        .font(.SDGothicBold(size: 16))
                        .foregroundColor(Color(uiColor: UIColor.primaryColor))
                        .padding(.leading, 30)
                        .padding(.trailing, 25)
                }
                
            }
            .fixedSize()
            
            Spacer()
        }
        .padding(.leading, 20)
    }
    
    var reportView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("하루 진단")
                    .font(.SDGothicBold(size: 16))
                    .foregroundColor(.init(uiColor: .grayColor4))
                    .padding(.leading, 20)
                Spacer()
                
                Button(action: {
                    viewModel.buttonClick.send(2)
                }, label: {
                    Image("EditButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 88, height: 24)
                })
                .padding(.trailing, 20)
            }
            
            
            feelingView
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color(uiColor: UIColor.backGroundWhiteColor))
                Text(type == .home ? viewModel.reportData?.todayReport ?? "" : historyViewModel.weeklyCalendarData?.data?.report?.todayReport)
                    .font(.SDGothicRegular(size: 14))
                    .foregroundColor(.init(uiColor: .grayColor3))
                    .lineSpacing(6)
                    .frame(width: UIScreen.main.bounds.width - 70)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
            }
            .fixedSize()
            .padding(.leading, 20)
        }
    }
    
    var careView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("칭찬 처방")
                    .font(.SDGothicBold(size: 16))
                    .foregroundColor(.init(uiColor: .grayColor4))
                    .padding(.leading, 20)
                Spacer()
                
                Button(action: {
                    viewModel.buttonClick.send(5)
                }, label: {
                    Image("EditButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 88, height: 24)
                })
                .padding(.trailing, 20)
                    
            }
            
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color(uiColor: UIColor.backGroundWhiteColor))
                VStack(alignment: .leading) {
                    Text(type == .home ? (viewModel.careData?.careMsg1 ?? "")+"\n\(viewModel.careData?.careMsg2 ?? "")" : (historyViewModel.weeklyCalendarData?.data?.care?.careMsg1 ?? "")+"\n\(historyViewModel.weeklyCalendarData?.data?.care?.careMsg2 ?? "")")
                        .font(.SDGothicRegular(size: 14))
                        .foregroundColor(.init(uiColor: .grayColor3))
                        .lineSpacing(6)
                        .frame(width: UIScreen.main.bounds.width - 70)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .frame(alignment: .leading)
                }
            }
            .fixedSize()
            .padding(.leading, 20)
        }
    }
    
    func getImage(idx: Int) -> String {
        switch idx {
        case 5:
            return "BVGood"
        case 4:
            return "BGood"
        case 3:
            return "BSoso"
        case 2:
            return "BBad"
        case 1:
            return "BVBad"
        default:
            return "BSoso"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {            
            ZStack {
                VStack {
                    Spacer()
                        .frame(height: 1)
                    
                    reportView
                        .overlay(
                            Color.white
                                .overlay(
                                    Text("아직 하루진단을 완료하지 않았어요!")
                                )
                                .opacity(type == .home ? (viewModel.reportData == nil && viewModel.dataIsReady ? 1 : 0) : historyViewModel.weeklyCalendarData?.data?.report == nil ? 1 : 0 )
                        )
                    careView
                        .overlay(
                            Color.white
                                .overlay(
                                    Text("아직 칭찬처방을 완료하지 않았어요!")
                                )
                                .opacity(type == .home ? (viewModel.careData == nil && viewModel.dataIsReady ? 1 : 0) : historyViewModel.weeklyCalendarData?.data?.care == nil ? 1 : 0)
                        )
                    
                    Spacer()
                        .frame(height: 50)
                }
                .opacity(type == .home ? ((viewModel.reportData != nil || viewModel.careData != nil) && viewModel.dataIsReady ? 1 : 0) : historyViewModel.weeklyCalendarData?.data?.report == nil && historyViewModel.weeklyCalendarData?.data?.care == nil ? 0 : 1)
                
                notYetImageView.opacity(type == .home ? ((viewModel.reportData == nil && viewModel.careData == nil) && viewModel.dataIsReady ? 1 : 0) : historyViewModel.weeklyCalendarData?.data?.care == nil && historyViewModel.weeklyCalendarData?.data?.report == nil && historyViewModel.dataIsReady ? 1 : 0)
                
                loadingView.opacity(type == .home ? ((viewModel.reportData == nil && viewModel.careData == nil) && !viewModel.dataIsReady ? 1 : 0) : !historyViewModel.dataIsReady ? 1 : 0)
            }
            .onReceive(historyViewModel.$selectWeeklyDate, perform: { value in
                print("뷰 안에서 작동",value)
                if let index = historyViewModel.calendarWeekList.firstIndex(where: { $0.day == value }) {
                    print(historyViewModel.calendarWeekList[index])
                    historyViewModel.weeklyCalendarData = historyViewModel.calendarWeekList[index]
                }
            })
        }
    }
}
