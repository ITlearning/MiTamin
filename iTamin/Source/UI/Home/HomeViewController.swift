//
//  HomeViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/15.
//

import UIKit
import SnapKit
import SwiftUI

extension HomeViewController {
    private func setAnimate() {
        view.bounds.origin.x = UIScreen.main.bounds.width - (UIScreen.main.bounds.width-5)
        self.mainTitleLabel.alpha = 0.0
        self.mainLogoImageView.alpha = 0.0
        mainTopYellowColorView.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.bounds.origin.x = 0
            self.mainTitleLabel.alpha = 1
            self.mainLogoImageView.alpha = 1
            self.mainTopYellowColorView.alpha = 1
        })
    }
    
    private func setTabBar() {
        tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "icon-home-mono"), selectedImage: UIImage(named: "icon-home-mono"))
        
    }
}

class HomeViewController: UIViewController {

    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    let scrollView = UIScrollView()
    
    let mainTopYellowColorView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = UIColor.mainTopYellowColor
        
        return mainView
    }()
    
    let mainCircleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Frame")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 1.0
        
        return imageView
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
    
    let currentDateLabel: UILabel = {
        let label = UILabel()
        label.text = "10.02 Sun"
        label.font = UIFont.SDGothicRegular(size: 12)
        label.textColor = UIColor.grayColor2
        
        return label
    }()
    
    let toDayMyTaminLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicBold(size: 18)
        label.text = "오늘의 마이타민"
        
        return label
    }()
    
    let notYetMyTaminImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NotYetImage")
        imageView.isHidden = true
        return imageView
    }()
    
    let notYetMyTaminLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 섭취한\n마이타민이 없어요"
        label.font = UIFont.SDGothicMedium(size: 18)
        label.textColor = UIColor.grayColor4
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAnimate()
        viewModel.checkStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        configureLayout()
        bindCombine()
        setCurrentDay()
    }

    private func bindCombine() {
        
        viewModel.buttonClick
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { idx in
                let myTaminVC = MyTaminViewController(index: idx)
                myTaminVC.modalPresentationStyle = .fullScreen
                self.present(myTaminVC, animated: true)
            })
            .cancel(with: cancelBag)
        
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
        
        viewModel.getLatestData
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in
                self.viewModel.loadLatestData()
            })
            .cancel(with: cancelBag)
    }
    
    private func setCurrentDay() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM.dd EEE"
        let result = dateFormatter.string(from: date)
        currentDateLabel.text = result
    }
    
    private func configureLayout() {
        let mainScrollView = UIHostingController(rootView: MainCollectionView(viewModel: self.viewModel))
        let myTaminReportView = UIHostingController(rootView: MyTaminReportView())
        
        view.addSubview(mainTopYellowColorView)
        view.addSubview(mainCircleImageView)
        view.addSubview(mainLogoImageView)
        view.addSubview(mainTitleLabel)
        view.addSubview(mainScrollView.view)
        view.addSubview(notYetMyTaminImage)
        view.addSubview(currentDateLabel)
        view.addSubview(toDayMyTaminLabel)
        view.addSubview(notYetMyTaminLabel)
        view.addSubview(myTaminReportView.view)
        
        mainScrollView.view.backgroundColor = .clear
        
        mainTitleLabel.alpha = 0.0
        mainTopYellowColorView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view)
            $0.height.equalTo(330)
        }
        
        mainCircleImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
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
        
        mainScrollView.view.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(45)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        currentDateLabel.snp.makeConstraints {
            $0.top.equalTo(mainScrollView.view.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        toDayMyTaminLabel.snp.makeConstraints {
            $0.top.equalTo(currentDateLabel.snp.bottom).offset(8)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        notYetMyTaminImage.snp.makeConstraints {
            $0.top.equalTo(toDayMyTaminLabel.snp.bottom).offset(40)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.width.equalTo(120)
            $0.height.equalTo(120)
        }
        
        notYetMyTaminLabel.snp.makeConstraints {
            $0.top.equalTo(notYetMyTaminImage.snp.bottom).offset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        myTaminReportView.view.snp.makeConstraints {
            $0.top.equalTo(toDayMyTaminLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

}

