//
//  HistoryResetView.swift
//  MiTamin
//
//  Created by Tabber on 2022/11/07.
//

import SwiftUI

struct ButtonModel {
    var name: String
    var description: String
}

enum ResetViewTouch {
    case mind
    case care
    case myDay
    case resetButton
}

protocol HistoryResetDelegate: AnyObject {
    func touchAction(action: ResetViewTouch)
}

struct HistoryResetView: View {
    
    @StateObject var viewModel: ResetViewController.ViewModel
    
    @State var buttonString: [ButtonModel] = [
        ButtonModel(name: "마음 진단", description: "마음 컨디션, 감정단어, 진단 내용, 이를 포함한 모든 통계가 초기화 됩니다."),
        ButtonModel(name: "칭찬 처방", description: "칭찬 카테고리, 칭찬 기록이 초기화됩니다."),
        ButtonModel(name: "마이데이", description: "위시리스트, 데이노트 내용이 초기화됩니다.")
    ]
    
    weak var delegate: HistoryResetDelegate?
    
    var body: some View {
        
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    
                    Image("icon-exclamation-circle-mono")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .padding(.bottom, 16)
                        .padding(.top, 40)
                    
                    Text("초기화를 진행할 경우")
                        .font(.SDGothicBold(size: 18))
                        .foregroundColor(Color(uiColor: .grayColor4))
                    Text("다시는 복구할 수 없습니다.")
                        .font(.SDGothicBold(size: 18))
                        .foregroundColor(Color(uiColor: .grayColor4))
                        .padding(.top, 4)
                    
                    Text("신중하게 선택한 뒤 아래의 초기화 버튼을 눌러주세요.")
                        .font(.SDGothicRegular(size: 14))
                        .foregroundColor(Color(uiColor: .grayColor3))
                        .padding(.top, 24)
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 8)
                        .foregroundColor(Color(hex: 0xF6F4F2))
                        .padding(.top, 40)
                    
                    HStack {
                        Text("초기화 하고자 하는 기록을 선택해주세요.")
                            .foregroundColor(Color(uiColor: .grayColor4))
                            .font(.SDGothicRegular(size: 14))
                        Spacer()
                    }
                    .padding(.top, 24)
                    .padding(.leading, 20)
                    
                    ForEach(buttonString.indices, id:\.self) { idx in
                        setButton(idx: idx)
                    }
                    
                    
                }
            }
            
            Spacer()
            
            Button(action: {
                delegate?.touchAction(action: .resetButton)
            }, label: {
                Text("초기화")
                    .font(.SDGothicBold(size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 56, alignment: .center)
                            .foregroundColor(Color(uiColor: .primaryColor))
                    )
            })
            .padding(.bottom, 20)
        }
        
        
    }
    
    func setButton(idx: Int) -> some View {
        Button(action: {
            switch idx {
            case 0:
                delegate?.touchAction(action: .mind)
            case 1:
                delegate?.touchAction(action: .care)
            case 2:
                delegate?.touchAction(action: .myDay)
            default:
                break
            }
        }, label: {
            HStack(alignment: .top) {
                Image(viewModel.selectIndex[idx] == 1 ? "check-circle" :"UnSelectButton")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                VStack(alignment:.leading, spacing: 0) {
                    Text(buttonString[idx].name)
                        .font(.SDGothicBold(size: 16))
                        .foregroundColor(Color(uiColor: .grayColor4))
                        .padding(.top, 3)
                    
                    Text(buttonString[idx].description)
                        .multilineTextAlignment(.leading)
                        .font(.SDGothicRegular(size: 12))
                        .foregroundColor(Color(uiColor: .grayColor3))
                        .padding(.top, 8)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        })
        
        
    }
}
