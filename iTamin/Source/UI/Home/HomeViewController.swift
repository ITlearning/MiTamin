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
        tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}

class HomeViewController: UIViewController {

    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    let mainLogoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "MainLogo")
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "태버님, 오늘도\n힘차게 시작해볼까요?"
        label.font = UIFont.notoRegular(size: 24)
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
                let text = "\(result?.nickname ?? "")님, \(result?.comment ?? "")"
                print()
                self.mainTitleLabel.text = text
            })
            .cancel(with: cancelBag)
    }
    
    private func configureLayout() {
        view.addSubview(mainLogoImageView)
        view.addSubview(mainTitleLabel)
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

