//
//  MindSelectView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/08.
//

import SwiftUI

struct MindSelectView: View {
    
    @State var mindButtonImage: [String] = [
        "VBad", "Bad", "Soso","Good","VGood"
    ]
    
    @State var mindDescription: [String] = [
        "매우 나빠요","나쁜 편이에요","그럭저럭이에요","좋은 편이에요","매우 좋아요!"
    ]
    
    @State var selectMindImage: Int = 0
    
    var buttonClickIndex: ((Int) -> ())?
    
    var body: some View {
        
        VStack {
            
            Image("B\(mindButtonImage[selectMindImage])")
                .resizable()
                .frame(width: 180, height: 180)
                .padding(.top, 24)
            
            Text("\"\(mindDescription[selectMindImage])\"")
                .font(.SDGothicBold(size: 24))
                .padding(.top, 24)
            
            HStack(spacing: 20) {
                ForEach(mindButtonImage.indices, id: \.self) { idx in
                    Button(action: {
                        selectMindImage = idx
                        buttonClickIndex?(idx)
                    }, label: {
                        Image(selectMindImage == idx ? "B"+mindButtonImage[idx] : mindButtonImage[idx])
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                }
            }
            .padding(.top, 40)
        }
        .padding(.horizontal, 20)
    }
}

struct MindSelectView_Previews: PreviewProvider {
    static var previews: some View {
        MindSelectView()
    }
}
