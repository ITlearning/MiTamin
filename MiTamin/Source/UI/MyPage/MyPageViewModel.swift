//
//  MyPageViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/10/23.
//

import Foundation
import Combine

extension MyPageViewController {
    class ViewModel: ObservableObject {
        
        var profileData = CurrentValueSubject<ProfileModel?, Error>(nil)
        @Published var myDayInfo: MyDayModel? = nil
        @Published var loading: Bool = false
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        @Published var userWithDrawal: Bool = false
        
        func withDrawal() {
            loading = true
            networkManager.userWithdrawal()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                    self.loading = false
                }, receiveValue: { value in
                    self.loading = false
                    self.userWithDrawal = true
                })
                .cancel(with: cancelBag)
        }
        
        func getMyDayInfo() {
            networkManager.getMyDayInformation()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    self.myDayInfo = value.data
                })
                .cancel(with: cancelBag)
        }
        
        func getProfile() {
            networkManager.getProfile()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    self.profileData.send(value.data)
                })
                .cancel(with: cancelBag)
        }
    }
}
