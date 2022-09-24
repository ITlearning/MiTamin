//
//  SceneDelegate.swift
//  iTamin
//
//  Created by Tabber on 2022/09/15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if UserDefaults.standard.bool(forKey: "isLogined") {
            window.rootViewController = RootTabBarViewController()
        } else {
            window.rootViewController = UINavigationController(rootViewController: LoginMainViewController())
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    func changeRootViewController (_ vc: UIViewController, animated: Bool) {
        // guard let으로 윈도우를 옵셔널 바인딩한 상황
        guard let window = self.window else { return }
        
        // 아까 위에서 설정한 window를 기준으로 RootViewController를 재설정하는 코드
        window.rootViewController = vc
        
        // 뷰가 변경될 때 이동하는 애니메이션과 시간등을 정의
        UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}

