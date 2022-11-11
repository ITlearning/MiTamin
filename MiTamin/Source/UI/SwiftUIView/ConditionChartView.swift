//
//  ConditionChartView.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import SwiftUI
import SwiftUICharts
import UIKit

struct ConditionChartView: View {
    
    @StateObject var viewModel: HistoryViewController.ViewModel
    @State var isOpen: Bool = false
    @State var data: LineChartData? = nil
    @State var week: [String] = ["일", "월", "화", "수", "목", "금", "토", "일"]
    @State var day: String = getDayOfWeek()
    var body: some View {
        VStack {
            if data != nil {
                ZStack {
                    Image("graph")
                        .resizable()
                    if isOpen {
                        LineChart(chartData: data ?? LineChartData(dataSets: LineDataSet(dataPoints: [LineChartDataPoint(value: 0.0)])))
                            .pointMarkers(chartData: data ?? LineChartData(dataSets: LineDataSet(dataPoints: [LineChartDataPoint(value: 0.0)])))
                            .padding()
                            .frame(height: 140)
                    }
                }
                .frame(height: 140)
                .padding(.horizontal, 20)
                HStack(spacing: 31) {
                    ForEach(week.indices, id:\.self) { idx in
                        Text(week[idx])
                            .font(.SDGothicRegular(size: 12))
                            .foregroundColor((day == week[idx]) && idx != 0 ? Color(uiColor: .grayColor4) : Color(uiColor: .grayColor2))
                            
                    }
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: 0xDBDBDB), lineWidth: 1)
                .padding(.horizontal, 20)
        )
        .onReceive(viewModel.$weeklyMentalList, perform: { value in
            data = weekOfData(value: value)
        })
    }
    
    static func getDayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from: Date())
        return convertStr
    }
    
    func weekOfData(value: [WeeklyMentalModel]) -> LineChartData {
        
        var dataPonits:[LineChartDataPoint] = []
        var week: [String] = []
        value.forEach { item in
            dataPonits.append(LineChartDataPoint(value: Double(item.mentalConditionCode), xAxisLabel: "", description: item.dayOfWeek))
            week.append(item.dayOfWeek)
        }
        
        self.week = week
        
        let data = LineDataSet(dataPoints: dataPonits,
        legendTitle: "",
                               pointStyle: PointStyle(pointSize: 10, borderColour: Color(uiColor: .primaryColor), fillColour: .white, lineWidth: 2, pointType: .filledOutLine, pointShape: .circle),
                               style: LineStyle(lineColour: ColourStyle(colours: [Color(uiColor: .primaryColor)],
                                                 startPoint: .top,
                                                 endPoint: .bottom),
                         lineType: .line))
        
        isOpen = data.dataPoints.contains(where: { $0.value != 0 })
        return LineChartData(dataSets: data,
                             metadata: ChartMetadata(title: "Some Data", subtitle: "A Week"),
                             xAxisLabels: ["일", "월", "화", "수", "목", "금", "토", "일"],
                             chartStyle: LineChartStyle(infoBoxPlacement: .header,
                                                        markerType: .full(attachment: .point),
                                                        xAxisLabelsFrom: .chartData(rotation: .degrees(0)),
                                                        baseline: .minimumWithMaximum(of: 5)))
    }
}
