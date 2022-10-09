//
//  CategoryBottomSheetView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/09.
//

import SwiftUI

struct CategoryBottomSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    var buttonTouch: ((String) -> ())?
    
    @State var menuTexts:[String] = [
        "이루어 낸 일",
        "잘한 일이나 행동",
        "노력하고 있는 부분",
        "긍정적인 변화나 깨달음",
        "감정, 생각 혹은 신체 일부분",
        "과거의 나",
        "기타"
    ]

    func listText(text: String) -> some View {
        Text(text)
            .font(Font.SDGothicMedium(size: 18))
            .foregroundColor(Color(uiColor: UIColor.grayColor4))
    }
    
    var body: some View {
        List {
            ForEach(menuTexts, id:\.self) { text in
                Button(action: {
                    buttonTouch?(text)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    listText(text: text)
                })
            }
        }.listStyle(.plain)
            .offset(x: -10)
    }
}
