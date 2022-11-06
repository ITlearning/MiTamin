//
//  ProfileBGView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/16.
//

import SwiftUI

struct ProfileBGView: View {
    var body: some View {
        Image("BG")
            .resizable()
            .scaledToFill()
            .padding(.horizontal, 20)
            .frame(height: 134)
    }
}

struct ProfileBGView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBGView()
    }
}
