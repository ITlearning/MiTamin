//
//  ViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import UIKit

extension UIViewController {
    
    func navigationConfigure(title: String = "") {
        let backButton = UIImage(named: "icon-arrow-left-small-mono")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = backButton
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.topItem?.title = title
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButton
        self.navigationController?.navigationBar.tintColor = UIColor.backButtonBlack
    }
    
    func moveToMain() {
        let rootTabBarViewController = RootTabBarViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(rootTabBarViewController, animated: true)
    }
    
    func moveToLogin() {
        let loginVC = UINavigationController(rootViewController: LoginMainViewController())
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginVC, animated: true)
    }
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
