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
                .frame(height: 360)
                .foregroundColor(Color.white)
                .overlay(
                    VStack(spacing: 0) {
                        Image("\(viewModel.alertText == "하루 진단하기" ? "Frame-2" : "Frame-3")")
                            .resizable()
                            .background(
                                RoundedCorners(color: Color(hex: 0xFFF6CF), tl: 20, tr: 20, bl: 0, br: 0)
                                    .frame(height: 194)
                            )
                            .frame(height: 194)
                            .offset(y: -25)
                        
                        Spacer()
                        
                        HStack {
                            Text("\(viewModel.alertText == "하루 진단하기" ? 3 : 4). \(viewModel.alertText)")
                                .font(.SDGothicBold(size: 24))
                                .foregroundColor(Color(uiColor: .grayColor4))
                         
                            
                            Spacer()
                        }
                        .padding(.leading, 32)
                        
                        HStack {
                            Text("오늘 하루 감정에 변화가 생겼나요?")
                                .font(.SDGothicMedium(size: 16))
                                .foregroundColor(Color(uiColor: .grayColor3))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 32)
                        
                        HStack {
                            Text("마이데이를 수정하시겠어요?")
                                .font(.SDGothicMedium(size: 16))
                                .foregroundColor(Color(uiColor: .grayColor3))
                                .padding(.top, 4)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 32)
                        
                        
                        Spacer()

                        HStack {
                            Button(action: {
                                cancelButtonAction?()
                            }, label: {
                              Text("패스하기")
                                    .font(.SDGothicBold(size: 16))
                                    .foregroundColor(Color(uiColor: .primaryColor))
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(uiColor: .primaryColor), lineWidth: 1)
                                            .foregroundColor(.clear)
                                            .frame(width: 146, height: 48)
                                    )
                            })
                            .frame(width: 146, height: 48)
                            
                            Button(action: {
                                viewModel.isEditStatus.send(false)
                                if viewModel.myTaminStatus.value != 4 {
                                    viewModel.loadDailyReport()
                                } else {
                                    viewModel.loadCareReport()
                                }
                                
                            }, label: {
                                Text("확인")
                                    .font(.SDGothicBold(size: 16))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundColor(Color(uiColor: .primaryColor))
                                            .frame(width: 146, height: 48)
                                    )
                            })
                            .frame(width: 146, height: 48)
                        }
                        .padding(.horizontal, 32)
                    }
                    
                )
        }
        .onReceive(viewModel.isEditStatus, perform: { value in
            withAnimation {
                self.isEdit = value
            }
        })
    }
}


struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                path.closeSubpath()
            }
            .fill(self.color)
        }
    }
}
