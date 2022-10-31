//
//  MyDayDetailView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/31.
//

import SwiftUI
import Kingfisher
import SkeletonUI

struct MyDayDetailView: View {
    @Environment(\.presentationMode) var presentation
    
    @State var myDayData: DayNoteModel? = DayNoteModel(daynoteId: 6, imgList: [
        "https://mytamin-bucket.s3.ap-northeast-2.amazonaws.com/DN-c4a5c93c-434a-4e8c-8f73-3b07be10f66c",
        "https://mytamin-bucket.s3.ap-northeast-2.amazonaws.com/DN-cf4ae39d-ff6a-4316-b104-c2a23f2655c7",
        "https://mytamin-bucket.s3.ap-northeast-2.amazonaws.com/DN-5a2bfc00-242d-46f4-83a0-fad78a1d8006"
    ], year: 2022, month: 10, wishText: "빵 나오는 시간에 맞춰서 갓 나온 빵 사먹기", note: "따끈따끈한 식빵에 우유는 역시 최고! 빵 나오는 시간에 맞춰서 나가니까 뭔가 부지런해진 기분이라 더 뿌듯하다.")
    @State var index: Int = 0
    @State var isDownload: Bool = false
    func close() {
        presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Spacer().frame(width: 0, height: 0.1)
                .padding(.top, 0)
            ScrollView {
                TabView(selection: $index, content: {
                    ForEach((myDayData?.imgList ?? []).indices, id:\.self, content: { idx in
                        KFImage(URL(string: myDayData?.imgList[idx] ?? ""))
                            .resizable()
                            .scaledToFill()
                            .tag(idx)
                            .frame(width: UIScreen.main.bounds.width, height: 362)
                            .clipped()
                    })
                })
                .frame(width: UIScreen.main.bounds.width, height: 362)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer()
                    .frame(width: 0, height: 12)
                
                HStack(spacing: 8) {
                    ForEach((myDayData?.imgList ?? []).indices, id:\.self) { idx in
                        ZStack {
                            Circle()
                                .strokeBorder(Color(uiColor: UIColor.primaryColor), lineWidth: 1)
                                .frame(width: 8, height: 8)
                            Circle()
                                .foregroundColor(idx == index ? Color(uiColor: UIColor.primaryColor) : Color.clear)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                
                HStack {
                    Text("\(String(myDayData?.year ?? 0))년 \(myDayData?.month ?? 0)월의 마이데이")
                        .font(.SDGothicRegular(size: 12))
                        .foregroundColor(Color(hex: 0x999999))
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                HStack {
                    Text(myDayData?.wishText)
                        .font(.SDGothicBold(size: 24))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                Spacer()
                    .frame(width: 0, height: 20)
                
                HStack {
                    Text(myDayData?.note)
                        .font(.SDGothicRegular(size: 16))
                        .foregroundColor(Color(uiColor: UIColor.grayColor4))
                        .lineSpacing(4)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.close()
                } label: {
                    Image("icon-arrow-left-small-mono")
                        .renderingMode(.original)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("마이데이 기록")
                    .font(.SDGothicRegular(size: 16))
                    .foregroundColor(Color(uiColor: UIColor.grayColor4))
            }
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    
                }, label: {
                    Image("more-horizontal")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            })
        }
    }
}

struct MyDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyDayDetailView()
    }
}
