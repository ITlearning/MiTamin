//
//  MindConfigViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/16.
//

import UIKit

class MindConfigViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(title: "감정관리", image: UIImage(named: "icon-headphone-mono"), selectedImage: UIImage(named: "icon-headphone-mono"))
        
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
