//
//  HomeViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/15.
//

import UIKit
import SnapKit
import SwiftUI
import SkeletonView

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
        mainView.backgroundColor = UIColor(rgb: 0xFFF6CF)
        
        return mainView
    }()
    
    let mainTopView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(rgb: 0xFFF6CF)
        return v
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
        
        imageView.image = UIImage(named: "mitamin")
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.mainTitleColor
        label.numberOfLines = 0
        label.isSkeletonable = true
        label.text = "dsadsasdaasds"
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
        label.isSkeletonable = true
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
        label.isSkeletonable = true
        return label
    }()
    
    let blackScreenView: UIView = {
        let bView = UIView()
        bView.backgroundColor = .black
        bView.alpha = 0.0
        
        return bView
    }()
    
    let loadingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "열심히 데이터를 불러오는중..🏃‍♂️"
        label.alpha = 0.0
        label.textColor = UIColor.white
        label.font = UIFont.SDGothicBold(size: 17)
        
        return label
    }()
    
    let bellButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Bell"), for: .normal)
        button.backgroundColor = .clear
        button.isHidden = true
        return button
    }()
    
    lazy var myTaminReportView = UIHostingController(rootView: MyTaminReportView(viewModel: self.viewModel, historyViewModel: HistoryViewController.ViewModel()))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.set(true, forKey: "tabChange")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setAnimate()
        navigationController?.isNavigationBarHidden = true  
        self.view.showAnimatedGradientSkeleton()
        
        if UserDefaults.standard.bool(forKey: "updateData") || UserDefaults.standard.bool(forKey: "AllResetMind") || UserDefaults.standard.bool(forKey: "AllResetCare") || UserDefaults.standard.bool(forKey: "NeedUpdateHistory") || UserDefaults.standard.bool(forKey: "DeleteData") {
            viewModel.checkStatus()
            UserDefaults.standard.set(false, forKey: "AllResetMind")
            UserDefaults.standard.set(false, forKey: "AllResetCare")
            UserDefaults.standard.set(false, forKey: "NeedUpdateHistory")
            UserDefaults.standard.set(false, forKey: "updateData")
            UserDefaults.standard.set(false, forKey: "DeleteData")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        configureLayout()
        bindCombine()
        setCurrentDay()
        viewModel.checkStatus()
    }

    private func bindCombine() {
        
        viewModel.serverLoadFailed
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                self.moveToLogin()
            })
            .cancel(with: cancelBag)
        
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
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                if value {
                    self.viewModel.loadDailyReport()
                    self.viewModel.loadCareReport()
                } else {
                    self.viewModel.loadLatestData()
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.loadingMainScreen
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                if value {
                    self.hideLoadingScreen()
                } else {
                    self.showLodingScreen()
                }
            })
            .cancel(with: cancelBag)
        
        bellButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] _ in
                guard let self = self else { return }
                
            })
            .cancel(with: cancelBag)
        
        viewModel.$reportData
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                if value != nil {
                    self.setSize()
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.$careData
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                if value != nil {
                    self.setSize()
                }
            })
            .cancel(with: cancelBag)
    }
    
    func setSize() {
        myTaminReportView.view.snp.remakeConstraints {
            $0.top.equalTo(toDayMyTaminLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        myTaminReportView.view.layoutSubviews()
        myTaminReportView.view.invalidateIntrinsicContentSize()
    }
    
    func showLodingScreen() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.4, animations: {
            self.blackScreenView.alpha = 0.4
            self.loadingTextLabel.alpha = 1.0
        })
    }
    
    func hideLoadingScreen() {
        UIApplication.shared.endIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.4, animations: {
            self.blackScreenView.alpha = 0.0
            self.loadingTextLabel.alpha = 0.0
        })
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
        
        
        myTaminReportView.view.invalidateIntrinsicContentSize()
        mainScrollView.view.isSkeletonable = true
        mainLogoImageView.isSkeletonable = true
        scrollView.backgroundColor = .white
        scrollView.bounces = false
        view.backgroundColor = .mainTopYellowColor
        view.addSubview(mainTopView)
        view.addSubview(scrollView)
        view.addSubview(mainLogoImageView)
        view.addSubview(bellButton)
        view.addSubview(blackScreenView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(mainLogoImageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(mainTopYellowColorView)
        scrollView.addSubview(mainCircleImageView)
        scrollView.addSubview(mainTitleLabel)
        scrollView.addSubview(mainScrollView.view)
        scrollView.addSubview(notYetMyTaminImage)
        scrollView.addSubview(currentDateLabel)
        scrollView.addSubview(toDayMyTaminLabel)
        scrollView.addSubview(notYetMyTaminLabel)
        scrollView.addSubview(myTaminReportView.view)
        view.addSubview(loadingTextLabel)
        
        
        blackScreenView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingTextLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        mainTopView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(350)
        }
        
        mainScrollView.view.backgroundColor = .clear
        
        mainTitleLabel.alpha = 0.0
        mainTopYellowColorView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(250)
        }
        
        mainCircleImageView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        mainLogoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.width.equalTo(73)
            $0.height.equalTo(16)
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
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
        }
        
        let sepView = UIView()
        
        scrollView.addSubview(sepView)
        
        sepView.snp.makeConstraints {
            $0.top.equalTo(myTaminReportView.view.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(60)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
        
        bellButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
    }

}

