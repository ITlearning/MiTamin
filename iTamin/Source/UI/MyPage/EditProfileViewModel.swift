//
//  EditProfileViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/10/23.
//

import Foundation
import Combine

extension EditProfileViewController {
    class ViewModel: ObservableObject {
        @Published var nickNameTextFieldString: String = "" //= CurrentValueSubject<String, Never>("")
        @Published var subMessageTextFieldString: String = "" // = CurrentValueSubject<String, Never>("")
        
        var userData: ProfileModel? = nil
    }
}
