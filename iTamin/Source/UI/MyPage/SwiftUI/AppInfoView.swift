//
//  AppInfoView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/31.
//

import SwiftUI

enum AppInfo {
    case Service
    case Privacy
    case Version
    case PasswordChange
    case ResetData
    case LogOut
    case UserOut
    
    func replaceType(idx: Int) -> AppInfo {
        switch idx {
        case 0:
            return .Service
        case 1:
            return .Privacy
        case 2:
            return .Version
        case 3:
            return .PasswordChange
        case 4:
            return .ResetData
        case 5:
            return .LogOut
        case 6:
            return .UserOut
        default:
            return .Privacy
        }
    }
}

protocol AppInfoDelegate: AnyObject {
    func touchAction(type: AppInfo)
}

struct AppInfoView: View {
    
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String,
            let build = dictionary["CFBundleVersion"] as? String else {return nil}

        let versionAndBuild: String = "\(version)"
        return versionAndBuild
    }
    
    @State var buttonText: [String] = ["서비스 이용약관", "개인정보 처리방침", "버전 "]
    @State var accountButtonText: [String] = ["비밀번호 변경", "기록 초기화", "로그아웃", "회원탈퇴"]
    
    @State var type: AppInfo = .Privacy
    
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
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 20)
            
            HStack {
                Text("계정 정보")
                    .font(.SDGothicBold(size: 18))
                    .foregroundColor(Color(uiColor: UIColor.grayColor4))
                Spacer()
            }
            .padding(.top, 15)
            .padding(.horizontal, 20)
            
            ForEach(accountButtonText.indices, id: \.self) { idx in
                HStack {
                    Button(action: {
                        delegate?.touchAction(type: type.replaceType(idx: idx+3))
                    }, label: {
                        makeButton(text: accountButtonText[idx])
                    })
                }
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 20)
        }
        
    }
    
    func makeButton(text: String) -> some View {
        HStack {
            Text(text.contains("버전") ? text+(version ?? "") : text)
                .font(.SDGothicMedium(size: 16))
                .foregroundColor(Color(uiColor: UIColor.grayColor4))
            Spacer()
            Image("icon-arrow-left-small-mono-1")
                .resizable()
                .frame(width: 18, height: 18)
                .opacity(text.contains("버전") || text.contains("회원") ? 0 : 1)
        }
        
    }
}

struct AppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView()
    }
}
