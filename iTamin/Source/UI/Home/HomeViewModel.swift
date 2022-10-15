//
//  HomeViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/27.
//

import UIKit
import SwiftUI
import SwiftKeychainWrapper
import Combine

extension HomeViewController {
    class ViewModel: ObservableObject {
        @Published var userData: WelComeModel?
        
        var buttonClick = PassthroughSubject<Int, Never>()
        var subTextPublisher = CurrentValueSubject<String, Never>("")
        var getLatestData = PassthroughSubject<Bool, Never>()
        var latestData = CurrentValueSubject<LatestMyTaminModel?, Never>(nil)
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        
        var mainCellItems = CurrentValueSubject<[MainCollectionModel], Never>(
            [MainCollectionModel(isDone: false, cellDescription: "숨 고르기", image: "MyTamin01"),
            MainCollectionModel(isDone: false, cellDescription: "감각 깨우기", image: "MyTamin02"),
            MainCollectionModel(isDone: false, cellDescription: "하루 진단하기", image: "MyTamin03"),
            MainCollectionModel(isDone: false, cellDescription: "칭찬 처방하기", image: "MyTamin04")]
        )
        
        init() {
            loadWelComeComment()
        }
        
        func checkStatus() {
            networkManager.checkMyTaminStatus()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { result in
                    self.mainCellItems.send([
                        MainCollectionModel(isDone: result.data.breathIsDone, cellDescription: "숨 고르기", image: "MyTamin01"),
                        MainCollectionModel(isDone: result.data.senseIsDone, cellDescription: "감각 깨우기", image: "MyTamin02"),
                        MainCollectionModel(isDone: result.data.reportIsDone, cellDescription: "하루 진단하기", image: "MyTamin03"),
                        MainCollectionModel(isDone: result.data.careIsDone, cellDescription: "칭찬 처방하기", image: "MyTamin04")
                    ])
                    
                    if result.data.reportIsDone && result.data.careIsDone {
                        self.getLatestData.send(true)
                    }
                })
                .cancel(with: cancelBag)
        }
        
        func loadWelComeComment() {
            networkManager.welcomeToServer()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] result in
                    guard let self = self else {return}
                    self.userData = result.data
                })
                .cancel(with: cancelBag)
        }
        
        func loadLatestData() {
            networkManager.getLatestMyTaminData()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { result in
                    self.latestData.send(result.data)
                    print(result.data)
                })
                .cancel(with: cancelBag)
        }
    }
}
