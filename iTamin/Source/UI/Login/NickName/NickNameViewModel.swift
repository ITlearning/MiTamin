//
//  NickNameViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import SwiftUI
import Combine
import CombineCocoa

extension NickNameViewController {
    class ViewModel: ObservableObject {
        @Published private var nickNameText: String = ""
        
        var isValid: AnyPublisher<Bool, Never> {
            return $nickNameText
                .map { text in
                    return text.count > 0 && text.count <= 9
                }
                .eraseToAnyPublisher()
        }
        
        func typingText(_ text: String) {
            nickNameText = text
        }
        
        func showUserName() -> String {
            return nickNameText
        }
    }
}
