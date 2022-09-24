//
//  TermsViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import SwiftUI
import Combine
import CombineCocoa

extension TermsViewController {
    class ViewModel: ObservableObject {
        @Published var allSelect: Bool = false
        @Published var oneButtonSelect: Bool = false
        @Published var twoButtonSelect: Bool = false
        
        var isAllSelect: AnyPublisher<Bool, Never> {
            return Publishers.CombineLatest($oneButtonSelect, $twoButtonSelect)
                .map { one, two in
                    return one && two
                }
                .eraseToAnyPublisher()
        }
    }
}
