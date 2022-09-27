//
//  HomeViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/15.
//

import UIKit
import SnapKit

extension HomeViewController {
    private func setAnimate() {
        view.bounds.origin.x = UIScreen.main.bounds.width - (UIScreen.main.bounds.width/1.5)
        self.mainTitleLabel.alpha = 0.0
        self.mainLogoImageView.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.bounds.origin.x = 0
            self.mainTitleLabel.alpha = 1
            self.mainLogoImageView.alpha = 1
        })
    }
    
    private func setTabBar() {
        tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "icon-home-mono"), selectedImage: UIImage(named: "icon-home-mono"))
        
        //tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}

class HomeViewController: UIViewController {

    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    let mainTopYellowColorView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = UIColor.mainTopYellowColor
        
        return mainView
    }()
    
    let mainLogoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "MainLogoColor")
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.mainTitleColor
        label.numberOfLines = 0
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        configureLayout()
        bindCombine()
    }

    private func bindCombine() {
        
        viewModel.$userData
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                
                if (result?.nickname ?? "") != "" {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.mainTitleLabel.alpha = 1.0
                        
                        let text = "\(result?.nickname ?? "")님, \(result?.comment ?? "")"
                        
                        let attributtedString = NSMutableAttributedString(string: text)
                        attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.primaryColor, range: (text as NSString).range(of: result?.nickname ?? ""))
                        
                        self.mainTitleLabel.attributedText = attributtedString
                        
                    })
                }
                
                
            })
            .cancel(with: cancelBag)
    }
    
    private func configureLayout() {
        view.addSubview(mainTopYellowColorView)
        view.addSubview(mainLogoImageView)
        view.addSubview(mainTitleLabel)
        mainTitleLabel.alpha = 0.0
        mainTopYellowColorView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view)
            $0.height.equalTo(300)
        }
        
        mainLogoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.width.equalTo(92)
            $0.height.equalTo(24)
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainLogoImageView.snp.bottom).offset(29)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(36)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(70)
        }
    }

}

