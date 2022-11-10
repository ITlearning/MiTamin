//
//  CategoryView.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import SwiftUI


struct CategoryView: View {
    
    
    @StateObject var viewModel: CareHistoryViewController.ViewModel
    
    @State var category: [String] = ["이루어낸 일", "잘한 일이나..."]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(spacing: 0) {
                ForEach(viewModel.selectIndex, id: \.self) { item in
                    roundView(text: returnString(item: item), item: item)
                }
            }
        })
    }
    
    func roundView(text: String, item: Int) -> some View {
        Text(text)
            .font(.SDGothicMedium(size: 12))
            .foregroundColor(Color(uiColor: .primaryColor))
            .padding()
            .padding(.horizontal, 5)
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(uiColor: .primaryColor), lineWidth: 1)
                        .foregroundColor(.clear)
                        .frame(height: 24)
                        .padding(.leading, 10)
                        .padding(.top, -2)
                        .offset(x: 4, y: 0)
                    HStack {
                        Spacer()
                        Button(action: {
                            if let index = viewModel.selectIndex.firstIndex(where: { $0 == item }) {
                                viewModel.selectIndex.remove(at: index)
                            }
                        }, label: {
                            Image("icon-x-mono")
                                .resizable()
                                .frame(width: 15, height: 15)
                        })
                        .padding(.top, -2)
                    }
                }
            )
    }
    
    func returnString(item: Int) -> String {
        switch item {
        case 1:
            return "이루어 낸 일"
        case 2:
            return "잘한 일이나 행동"
        case 3:
            return "노력하고 있는 부분"
        case 4:
            return "긍정적인 변화나 깨달음"
        case 5:
            return "감정, 생각 혹은 신체 일부분"
        case 6:
            return "과거의 나"
        case 7:
            return "기타"
        default:
            return ""
        }
    }
}
