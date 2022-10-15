//
//  MyTaminReportView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/09.
//

import SwiftUI

struct MyTaminReportView: View {
    
    //@StateObject var viewModel: HomeViewController.ViewModel
    
    //@State var dataModel: LatestMyTaminModel
    
    var feelingView: some View {
        HStack {
            Image("BVGood")
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
                    Text("#hashTag")
                        .font(.SDGothicRegular(size: 12))
                        .foregroundColor(Color(uiColor: UIColor.grayColor3))
                        .padding(.leading, 30)
                        .padding(.trailing, 25)
                        .multilineTextAlignment(.leading)
                    Text("Text Field")
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
            Text("하루 진단")
                .font(.SDGothicBold(size: 16))
                .foregroundColor(.init(uiColor: .grayColor4))
                .padding(.leading, 20)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color(uiColor: UIColor.backGroundWhiteColor))
                Text("오늘 아침에 미리 날씨를 보고 우산을 챙겨서 이전처럼 편의점에서 불필요하게 우산을 살 필요가 없었어. 학교에서는 좀 많이 졸렸어. 다음부터는 일찍 자는게 좋을 것 같아.")
                    .font(.SDGothicRegular(size: 14))
                    .foregroundColor(.init(uiColor: .grayColor3))
                    .lineSpacing(6)
                    .frame(width: UIScreen.main.bounds.width - 80)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
            }
            .fixedSize()
            .padding(.leading, 20)
        }
    }
    
    var careView: some View {
        VStack(alignment: .leading) {
            Text("칭찬 처방")
                .font(.SDGothicBold(size: 16))
                .foregroundColor(.init(uiColor: .grayColor4))
                .padding(.leading, 20)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color(uiColor: UIColor.backGroundWhiteColor))
                
                Text("오늘 계획했던 일을 전부 했어. 성실하려 노력하는 내 모습이 좋아.")
                    .font(.SDGothicRegular(size: 14))
                    .foregroundColor(.init(uiColor: .grayColor3))
                    .lineSpacing(6)
                    .frame(width: UIScreen.main.bounds.width - 80)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
            }
            .fixedSize()
            .padding(.leading, 20)
        }
    }
    
    func getImage(idx: Int) -> String {
        switch idx {
        case 1:
            return "BVGood"
        case 2:
            return "BGood"
        case 3:
            return "BSoso"
        case 4:
            return "BBad"
        case 5:
            return "BVBad"
        default:
            return "BSoso"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Spacer()
                    .frame(height: 1)
                
                feelingView
                reportView
                careView
                
                Spacer()
                    .frame(height: 50)
            }
            .background(GeometryReader{
                Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
            })
            .onPreferenceChange(ViewOffsetKey.self, perform: {
                print("Offset, \($0)")
            })
        }.coordinateSpace(name: "scroll")
    }
}

struct MyTaminReportView_Previews: PreviewProvider {
    static var previews: some View {
        MyTaminReportView()
    }
}


struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
