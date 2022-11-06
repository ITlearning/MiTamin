//
//  MindSelectView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/08.
//

import SwiftUI
import Combine

extension UserDefaults {
    @objc dynamic var userValue: Int {
        return integer(forKey: .mindSelectIndex)
    }
}

struct MindSelectView: View {
    
    @StateObject var viewModel: MindSelectViewModel
    
    var buttonClickIndex: ((Int) -> ())?
    
    var body: some View {
        VStack {
            Image("B\(viewModel.mindButtonImage[viewModel.index])")
                .resizable()
                .frame(width: 180, height: 180)
                .padding(.top, 24)
            
            Text("\"\(viewModel.mindDescription[viewModel.index])\"")
                .font(.SDGothicBold(size: 24))
                .padding(.top, 24)
            
            HStack(spacing: 20) {
                ForEach(viewModel.mindButtonImage.indices, id: \.self) { idx in
                    Button(action: {
                        viewModel.index = idx
                        buttonClickIndex?(idx)
                    }, label: {
                        Image(viewModel.index == idx ? "B"+viewModel.mindButtonImage[idx] : viewModel.mindButtonImage[idx])
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
