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
    var doneAction: (([Int]) -> ())?
    var type: CategoryOpenType = .write
    var index: [Int] = [] {
        didSet {
            selectIndex = index
        }
    }
    @State var selectIndex: [Int] = []
    
    @State var menuTexts:[String] = [
        "이루어 낸 일",
        "잘한 일이나 행동",
        "노력하고 있는 부분",
        "긍정적인 변화나 깨달음",
        "감정, 생각 혹은 신체 일부분",
        "과거의 나",
        "기타"
    ]

    func listText(text: String, idx: Int) -> some View {
        
        HStack {
            Text(text)
                .font(.SDGothicMedium(size: 18))
                .foregroundColor(Color(uiColor: UIColor.grayColor4))
            
            Spacer()
            
            if type == .history {
                Image("check")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .opacity(selectIndex.contains(where: { $0 == idx+1 }) ? 1 : 0)
            }
        }
        .padding(.horizontal, 20)
        
        
    }
    
    var body: some View {
        
        VStack {
            List {
                ForEach(menuTexts.indices, id:\.self) { idx in
                    Button(action: {
                        if type == .write {
                            buttonTouch?(menuTexts[idx], idx)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            if let index = selectIndex.firstIndex(where: { $0 == idx+1 }) {
                                selectIndex.remove(at: index)
                            } else {
                                selectIndex.append(idx+1)
                            }
                        }
                    }, label: {
                        listText(text: menuTexts[idx], idx: idx)
                    })
                }
            }.listStyle(.plain)
                .padding(.top, 24)
                .navigationBarHidden(true)
                .offset(x: -10)
            
            if type == .history {
                Button(action: {
                    if type == .write {
                        doneAction?([])
                    } else {
                        doneAction?(selectIndex)
                    }
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
        .onAppear {
            if type == .history {
                selectIndex = index
            }
        }
    }
}
