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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let homeVC = HomeViewController()
        let historyVC = HistoryViewController()
        let mindConfigVC = MindConfigViewController()
        let myPageVC = MyPageViewController()
        
        let viewControllers = [homeVC, historyVC, mindConfigVC, myPageVC]
        viewControllers.forEach({ $0.view.backgroundColor = UIColor.white })
        viewControllers.forEach({ $0.navigationController?.isNavigationBarHidden = true })
        self.setViewControllers(viewControllers, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindButtonAction() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.5, x: 0, y: 0, blur: 3)
        tabBar.unselectedItemTintColor = UIColor.tabBarUnSelectColor
        tabBar.tintColor = UIColor.selectTabBarColor
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 12
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //tabBar.clipsToBounds = true
        tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 52, bottom: 0, right: 0)
        //view.bringSubviewToFront(tabBar)
        
        
    }

}
