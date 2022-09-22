//
//  MyPageViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/16.
//

import UIKit

class MyPageViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
