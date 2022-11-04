//
//  TextView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/01.
//

import SwiftUI

struct TextView: View {
    
    @State var text: String
    
    var body: some View {
        Text(text)
            .font(Font.SDGothicRegular(size: 14))
            .multilineTextAlignment(.center)
            .lineSpacing(8)
    }
}
