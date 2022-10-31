//
//  AppInfoView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/31.
//

import SwiftUI

enum AppInfo {
    case Account
    case Service
    case Privacy
    case Version
    
    func replaceType(idx: Int) -> AppInfo {
        switch idx {
        case 0:
            return .Account
        case 1:
            return .Service
        case 2:
            return .Privacy
        case 3:
            return .Version
        default:
            return .Account
        }
    }
}

protocol AppInfoDelegate: AnyObject {
    func touchAction(type: AppInfo)
}

struct AppInfoView: View {
    
    @State var buttonText: [String] = ["계정관리", "서비스 이용약관", "개인정보 처리방침", "버전 "]
    
    @State var type: AppInfo = .Account
    
    weak var delegate: AppInfoDelegate?
    
    var body: some View {
        VStack {
            ForEach(buttonText.indices, id: \.self) { idx in
                HStack {
                    Button(action: {
                        delegate?.touchAction(type: type.replaceType(idx: idx))
                    }, label: {
                        makeButton(text: buttonText[idx])
                    })
                }
                .padding(.vertical, 3)
            }
            .padding(.horizontal, 20)
        }
    }
    
    func makeButton(text: String) -> some View {
        HStack {
            Text(text)
                .font(.SDGothicMedium(size: 16))
                .foregroundColor(Color(uiColor: UIColor.grayColor4))
            
            Spacer()
            
            Image("icon-arrow-left-small-mono-1")
                .resizable()
                .frame(width: 18, height: 18)
        }
        
    }
}

struct AppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView()
    }
}
