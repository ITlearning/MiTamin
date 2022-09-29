//
//  MainCollectionView.swift
//  iTamin
//
//  Created by Tabber on 2022/09/28.
//

import SwiftUI

struct MainCollectionView: View {
    
    @StateObject var viewModel: HomeViewController.ViewModel
    
    func mainCellView(idx: Int, item: MainCollectionModel) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 196, height: 150)
                .foregroundColor(Color.white)
                .background(Color.black.opacity(0.1)
                    .shadow(color: Color.black.opacity(0.1), radius: 0, x: 0, y: 8)
                    .blur(radius: 10)
                )
            
//            Image(item.image)
//                .resizable()
//                .frame(width: 184, height: 118)
//                .offset(x: 11.5, y: 18)
            
            HStack(alignment: .center,spacing: 8) {
                Text("\(idx+1)")
                    .font(Font.SDGothicBold(size: 18))
                    .foregroundColor(Color(uiColor: UIColor.primaryColor))
                    .multilineTextAlignment(.center)
                Text("\(item.cellDescription)")
                    .font(Font.SDGothicMedium(size: 18))
                    .foregroundColor(Color(uiColor: UIColor.grayColor4))
                    .multilineTextAlignment(.center)
            }
            .padding(.leading, 12)
            .padding(.top, 16)
            
            VStack(alignment: .center) {
                Spacer()
                
                Button(action: {
                    viewModel.buttonClick.send(idx)
                }, label: {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(uiColor: item.isDone ? UIColor.grayColor1 : UIColor.primaryColor))
                        .frame(width: 172, height: 40)
                        .overlay(
                            Text(item.isDone ? "완료" : "시작하기")
                                .font(Font.SDGothicBold(size: 16))
                                .foregroundColor(Color.white)
                        )
                })
                .offset(x: 12, y: -16)
            }
            
        }
        .frame(width: 250, height: 150)
        .background(Color.clear)
        
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -30) {
                ForEach(viewModel.mainCellItems.indices, id:\.self) { idx in
                    mainCellView(idx: idx, item: viewModel.mainCellItems[idx])
                }
            }
            .frame(height: 200)
            .background(Color.clear)
        }
        .background(Color.clear)
    }
}

