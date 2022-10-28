//
//  EditProfileViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/10/23.
//

import Foundation
import Combine
import UIKit

extension EditProfileViewController {
    class ViewModel: ObservableObject {
        @Published var nickNameTextFieldString: String = "" //= CurrentValueSubject<String, Never>("")
        @Published var subMessageTextFieldString: String = "" // = CurrentValueSubject<String, Never>("")
        var editImage: UIImage? = nil
        var imageEdit: Bool = false
        var userData: ProfileModel? = nil
        var cancelBag = CancelBag()
        var networkManager = NetworkManager()
        var isOpen: Bool = false
        var profileEditSuccess = PassthroughSubject<Void, Error>()
        
        func editProfile() {
            networkManager.editProfile(imageEdit: imageEdit ? "T" : "F", nickName: nickNameTextFieldString, sub: subMessageTextFieldString, image: imageEdit ? editImage : UIImage())
                .receive(on: DispatchQueue.global())
                .sink(receiveCompletion: { value in
                    self.profileEditSuccess.send(())
                }, receiveValue: { value in
                    print(value.message)
                    self.profileEditSuccess.send(())
                })
                .cancel(with: cancelBag)
        }
    }
}