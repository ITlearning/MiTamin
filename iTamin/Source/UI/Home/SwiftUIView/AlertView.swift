//
//  AlertView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/15.
//

import SwiftUI

struct AlertView: View {
    
    @StateObject var viewModel: MyTaminViewController.ViewModel
    
    var cancelButtonAction: (() -> ())?
    @State var isEdit: Bool = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .padding(.horizontal, 36)
                .frame(height: 240)
                .foregroundColor(Color.white)
                .overlay(
                    VStack(spacing: 0) {
                        Image("Mainillustration")
                            .resizable()
                            .frame(width: 62.29, height: 62.29)
                            .padding(.top, 40)
                        
                        Spacer()
                        
                        Text("새로운 사전이 있으셨나 보네요.")
                        Text("하루 진단하기를 수정하시겠어요?")
                        
                        Spacer()

                        Rectangle()
                            .foregroundColor(Color(uiColor: .grayColor6))
                            .frame(height: 1)

                        HStack {
                            Button(action: {
                                cancelButtonAction?()
                            }, label: {
                              Text("취소")
                                    .foregroundColor(.black)
                                    .frame(width: 151.5, height: 41.84)
                            })
                            .frame(width: 151.5, height: 41.84)
                            
                            Rectangle()
                                .foregroundColor(Color(uiColor: .grayColor6))
                                .frame(width: 1, height: 42)
                            
                            Button(action: {
                                viewModel.isEditStatus.send(false)
                            }, label: {
                                Text("확인")
                                    .foregroundColor(.black)
                                    .frame(width: 151.5, height: 41.84)
                            })
                            .frame(width: 151.5, height: 41.84)
                        }
                    }
                    
                )
        }
        .opacity(isEdit ? 1 : 0)
        .onReceive(viewModel.isEditStatus, perform: { value in
            withAnimation {
                self.isEdit = value
            }
        })
    }
}
