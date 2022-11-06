//
//  CategoryPickerView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/09.
//

import SwiftUI

struct CategoryPickerView: View {
    
    @StateObject var viewModel: CategoryCollectionViewModel
    
    var onTap: (() -> ())?
    
    var categoryView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.white)
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color(uiColor: UIColor.grayColor5), lineWidth: 1)
            
            HStack {
                Text(viewModel.text)
                    .font(Font.SDGothicRegular(size: 14))
                    .foregroundColor(Color(uiColor: UIColor.grayColor2))
                Spacer()
                
                Image("arrowDown")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding(.trailing, 15)
            }
            .padding(.leading, 16)
        }
        .frame(height: 48)
        .onTapGesture {
            onTap?()
        }
        .navigationBarHidden(true)
    }
    
    var body: some View {
        categoryView
    }
}
