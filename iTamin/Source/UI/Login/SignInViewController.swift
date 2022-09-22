//
//  SignInViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/23.
//

import UIKit
import SwiftUI

class SignInViewController: UIViewController {

    private let emailTextField: UITextField = {
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configureLayout() {
        view.backgroundColor = .white
        
    }

}


struct SignInViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SignInViewController()
        }
        .previewDevice("iPhone 13")
    }
}
