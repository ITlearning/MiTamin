//
//  MyTaminViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/29.
//

import SwiftUI
import UIKit
import Combine

struct MyTaminModel {
    var image: String
    var mainTitle: String
    var subTitle: String
    var TotalTime: Int?
    var isDone: Bool
}

extension MyTaminViewController {
    class ViewModel: ObservableObject {
        var myTaminStatus = CurrentValueSubject<Int, Never>(1)
        var currentIndex: Int = 0
        var placeHolder: [String] = ["오늘 아침의 나에게 하루를 진단해준다면?", "스스로를 칭찬해주세요!", "대단해, 발전하고 있어, 역시 나야 등"]
        var selectMindIndex = CurrentValueSubject<Int, Never>(5)
        var selectMindTexts = CurrentValueSubject<[String], Never>([])
        var selectCategoryText = CurrentValueSubject<String, Never>("")
        var mainTextViewData = CurrentValueSubject<String, Never>("")
        var subTextViewData = CurrentValueSubject<String, Never>("")
        var dailyReportData = CurrentValueSubject<String, Never>("")
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        
        var myTaminModel: [MyTaminModel] = [
            MyTaminModel(image: "myTaminTimerImage", mainTitle: "1. 숨고르기", subTitle: "코로 천천히 숨을 들이 마셨다가\n배에 가득 담긴 공기를 잠시 느끼고\n천천히 내뱉어 보세요.", TotalTime: 5, isDone: false),
            MyTaminModel(image: "myTaminTimerImage02", mainTitle: "2. 감각 깨우기", subTitle: "편한 자세로 눈을 감고 주변의 소리에 귀를 기울여보세요. 다음에는 코로 들어오는 주변의 냄새를 느껴보고 손바닥에 느껴지는 감각에도 신경을 기울여봅니다.", TotalTime: 180, isDone: false),
            MyTaminModel(image: "myTaminTimerImage03", mainTitle: "3. 하루 진단하기", subTitle: "오늘의 마음 컨디션은 어떤가요?", isDone: false),
            MyTaminModel(image: "myTaminTimerImage03", mainTitle: "3. 하루 진단하기", subTitle: "감정을 진찰해볼까요?", isDone: false),
            MyTaminModel(image: "myTaminTimerImage03", mainTitle: "3. 하루 진단하기", subTitle: "오늘 하루를 진단해주세요.", isDone: false),
            MyTaminModel(image: "myTaminTimerImage04", mainTitle: "4. 칭찬 처방하기", subTitle: "어떤 부분을 칭찬해볼까요?", isDone: false)
        ]
        
        
        private var mindSet: [Int: [String]] = [
            0: ["지치는", "실망한", "절망적인", "무서운",
                "혼란스러운", "화나는", "자책하는", "상처받은",
                "역겨운", "끔찍한", "수치스러운",
                "미어지는", "우울한", "서러운", "죄스러운"],
            1: [
                "피곤한", "기운없는", "실망한", "걱정되는",
                "긴장되는", "불편한", "못마땅한", "쓸쓸한",
                "우울한", "서운한", "미안한", "어이없는"
                ,"지겨운", "답답한"],
            2: ["평온한", "무념무상인", "무난한", "덤덤한",
                "지루한", "심심한", "권태로운", "귀찮은",
                "무기력한", "쓸쓸한","외로운", "허전한", "부러운"],
            3: ["즐거운", "행복한", "기쁜", "감사한", "편안한",
                "평화로운", "아늑한", "따뜻한", "만족한",
                "뿌듯한", "설레는", "개운한", "홀가분한"],
            4: ["신나는", "즐거운", "찬란한", "활기찬",
                "행복한", "감사한", "감동적인", "기대되는",
                "만족한", "뿌듯한", "설레는", "상쾌한", "후련한"]
        ]
        
        func sendDailyReport() {
            networkManager.reportNewDaily(condition: selectMindIndex.value, tags: selectMindTexts.value, todayReport: dailyReportData.value)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { result in
                    print(result.data)
                })
                .cancel(with: cancelBag)
        }
        
        func breathSuccess() {
            networkManager.breathCheckToServer()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in}, receiveValue: { result in
                    print(result)
                })
                .cancel(with: cancelBag)
        }
        func senseSuccess() {
            networkManager.senseCheckToServer()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in}, receiveValue: { result in
                    print(result)
                })
                .cancel(with: cancelBag)
        }
        
        func appendMindSet(idx: Int, value: [String]) {
            mindSet.updateValue(value, forKey: idx)
        }
        
        func showMindSet(idx: Int) -> [String] {
            return mindSet[idx] ?? []
        }
    }
    
}
