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
        
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        
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
