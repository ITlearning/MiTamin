//
//  MainSubTitleView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/09.
//

import SwiftUI

struct MainSubTitleView: View {
    
    @State var mainTitle: String
    @State var subTitle: String
    
    var body: some View {
        VStack {
            HStack {
                Text(mainTitle)
                    .font(.SDGothicBold(size: 24))
                Spacer()
            }
            
            Spacer()
                .frame(height: 30)
            
            HStack {
                Text(subTitle)
                    .font(.SDGothicMedium(size: 18))
                    .foregroundColor(Color(uiColor: UIColor.grayColor3))
                Spacer()
            }
        }
    }
}
