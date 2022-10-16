//
//  ProfileBGView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/16.
//

import SwiftUI

struct ProfileBGView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 100)
                .padding(.horizontal, 20)
                .foregroundColor(Color(uiColor: UIColor.mainTopYellowColor))
            
            HStack {
                Spacer()
                
                Image("MyPageOrange")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .rotationEffect(.radians(-5.5))
                    .padding(.trailing, -20)
                    .padding(.bottom, -25)
                
            }
            
        }
    }
}

struct ProfileBGView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBGView()
    }
}
