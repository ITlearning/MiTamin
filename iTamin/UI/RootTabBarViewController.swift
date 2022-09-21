//
//  RootTabBarViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/16.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class RootTabBarViewController: UITabBarController {

    private let homeVCButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "house"), for: .normal)
        button.setTitle("홈", for: .normal)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let homeVC = HomeViewController()
        let historyVC = HistoryViewController()
        let mindConfigVC = MindConfigViewController()
        let myPageVC = MyPageViewController()
        
        let viewControllers = [homeVC, historyVC, mindConfigVC, myPageVC]
        viewControllers.forEach({ $0.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00) })
        self.setViewControllers(viewControllers, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindButtonAction() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = UIColor.tabBarUnSelectColor
        tabBar.tintColor = UIColor.tabBarSelectColor
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 12
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.clipsToBounds = true
        tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 52, bottom: 0, right: 0)
        //view.bringSubviewToFront(tabBar)
        
        
    }

}
