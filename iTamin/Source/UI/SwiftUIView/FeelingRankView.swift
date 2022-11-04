//
//  FeelingRankView.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import SwiftUI

struct FeelingRankView: View {
    
    @State var items: [FeelingRankModel] = [
        FeelingRankModel(feeling: "행복한", count: 3),
        FeelingRankModel(feeling: "뿌듯한", count: 7),
        FeelingRankModel(feeling: "지치는", count: 5)
    ]
    
    func roundView(idx: Int, item: FeelingRankModel) -> some View {
        
        HStack(spacing: 0) {
            Text("\(idx+1)")
                .font(.SDGothicMedium(size: 14))
                .foregroundColor(Color(uiColor: .grayColor4))
                .padding()
                .background(
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(hex: 0xFFEB85))
                )
                .padding(.leading, 16)
            
            Text(item.feeling)
                .font(.SDGothicMedium(size: 16))
            
            Spacer()
            
            Text("\(item.count)회")
                .font(.SDGothicBold(size: 16))
                .padding(.trailing, 17)
                .foregroundColor(Color(uiColor: .primaryColor))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: 0xDBDBDB), lineWidth: 1)
                .foregroundColor(.clear)
        )
    }
    
    var body: some View {
        VStack {
            ForEach(items.indices, id:\.self) { idx in
                roundView(idx: idx, item: items[idx])
                    .padding(.horizontal, 20)
                    .frame(height: 56)
            }
        }
    }
}

struct FeelingRankView_Previews: PreviewProvider {
    static var previews: some View {
        FeelingRankView()
    }
}
