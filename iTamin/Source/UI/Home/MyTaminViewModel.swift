//
//  MyTaminViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/29.
//

import SwiftUI
import UIKit
import Combine

extension MyTaminViewController {
    class ViewModel: ObservableObject {
        var myTaminStatus = CurrentValueSubject<[Bool], Never>([false, false, false, false])
        
        
        
    }
}
