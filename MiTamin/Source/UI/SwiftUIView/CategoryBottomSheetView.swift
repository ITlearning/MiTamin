//
//  CategoryBottomSheetView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/09.
//

import SwiftUI

enum CategoryOpenType {
    case write
    case history
}

struct CategoryBottomSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    var buttonTouch: ((String, Int) -> ())?
    var doneAction: (() -> ())?
    var type: CategoryOpenType = .write
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
            .font(.SDGothicMedium(size: 18))
            .foregroundColor(Color(uiColor: UIColor.grayColor4))
    }
    
    var body: some View {
        
        VStack {
            List {
                ForEach(menuTexts.indices, id:\.self) { idx in
                    Button(action: {
                        buttonTouch?(menuTexts[idx], idx)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        listText(text: menuTexts[idx])
                    })
                }
            }.listStyle(.plain)
                .padding(.top, 24)
                .navigationBarHidden(true)
                .offset(x: -10)
            
            if type == .history {
                Button(action: {
                    doneAction?()
                }, label: {
                    Text("적용하기")
                        .foregroundColor(.white)
                        .font(.SDGothicBold(size: 16))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color(uiColor: .primaryColor))
                                .frame(width: UIScreen.main.bounds.width - 40, height: 56)
                        )
                })
            }
        }
    }
}
