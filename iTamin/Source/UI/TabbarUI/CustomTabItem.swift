////
////  BottomStackItem.swift
////  iTamin
////
////  Created by Tabber on 2022/09/21.
////
//
//import UIKit
//
//enum CustomTabItem: String, CaseIterable {
//    case home
//    case history
//    case mindConfig
//    case myPage
//}
// 
//extension CustomTabItem {
//    var viewController: UIViewController {
//        switch self {
//        case .home:
//            return HomeViewController()
//        case .history:
//            return HistoryViewController()
//        case .mindConfig:
//            return MindConfigViewController()
//        case .myPage:
//            return MyPageViewController()
//        }
//    }
//    
//    var icon: UIImage? {
//        switch self {
//        case .history:
//            return UIImage(systemName: "magnifyingglass.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
//        case .mindConfig:
//            return UIImage(systemName: "heart.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
//        case .home:
//            return UIImage(systemName: "person.crop.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
//        case .myPage:
//            
//        }
//    }
//    
//    var selectedIcon: UIImage? {
//        switch self {
//        case .history:
//            return UIImage(systemName: "magnifyingglass.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
//        case .mindConfig:
//            return UIImage(systemName: "heart.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
//        case .home:
//            return UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
//        }
//    }
//    
//    var name: String {
//        return self.rawValue.capitalized
//    }
//}
//
