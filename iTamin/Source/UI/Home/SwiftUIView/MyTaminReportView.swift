//
//  MyTaminReportView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/09.
//

import SwiftUI

struct MyTaminReportView: View {
    
    @StateObject var viewModel: HomeViewController.ViewModel
    
    @State var dataModel: LatestMyTaminModel? = nil
    @State var dataIsOn: Bool = true
    
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
            Image(getImage(idx: dataModel?.report.mentalConditionCode ?? 0))
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
                    Text(dataModel?.report.feelingTag ?? "")
                        .font(.SDGothicRegular(size: 12))
                        .foregroundColor(Color(uiColor: UIColor.grayColor3))
                        .padding(.leading, 30)
                        .padding(.trailing, 25)
                        .multilineTextAlignment(.leading)
                    Text("오늘은 기분이 \(dataModel?.report.mentalCondition ?? "")")
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
                Text(dataModel?.report.todayReport ?? "")
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
                    Text((dataModel?.care.careMsg1 ?? "")+"\n\(dataModel?.care.careMsg2 ?? "")")
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
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ZStack {
                    VStack {
                        Spacer()
                            .frame(height: 1)
                        
                        reportView
                        careView
                        
                        Spacer()
                            .frame(height: 50)
                    }
                    .opacity((self.dataModel == nil) && self.dataIsOn ? 0 : 1)
                    
                    notYetImageView.opacity((self.dataModel == nil) && !self.dataIsOn ? 0 : 1)
                    
                    loadingView.opacity(self.dataModel == nil ? 1 : 0)
                }
                
            }
            .background(GeometryReader{
                Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
            })
            .onPreferenceChange(ViewOffsetKey.self, perform: {
                print("Offset, \($0)")
            })
        }.coordinateSpace(name: "scroll")
        .onReceive(viewModel.latestData, perform: { value in
            withAnimation {
                self.dataModel = value
            }
        })
    }
}


struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
