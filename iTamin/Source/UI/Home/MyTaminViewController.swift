//
//  MyTaminViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/29.
//

import UIKit
import SwiftUI
import SnapKit
import Combine
import CombineCocoa

class MyTaminViewController: UIViewController {
    
    var viewModel: ViewModel = ViewModel()
    
    var cancelBag = CancelBag()
    
    let autoTextLabel: UILabel = {
        let label = UILabel()
        label.text = "자동 진행"
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-arrow-left-small-mono"), for: .normal)
        button.tintColor = UIColor.grayColor4
        
        return button
    }()
    
    let midNavTitle: UILabel = {
        let label = UILabel()
        label.text = "오늘의 마이타민"
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.tintColor = UIColor.grayColor4
        
        return button
    }()
    
    let toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.tintColor = UIColor.subYellowColor
        return toggle
    }()
    
    var myTaminCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationConfigure(title: "오늘의 마이타민")
        view.backgroundColor = .white
        
        backButton.tapPublisher
            .sink(receiveValue: { _ in
                let currentIndex = self.viewModel.myTaminStatus.value
                self.viewModel.myTaminStatus.send(currentIndex+1)
            })
            .cancel(with: cancelBag)
        
        cancelButton.tapPublisher
            .sink(receiveValue: { _ in
                self.dismiss(animated: true)
            })
            .cancel(with: cancelBag)
        
        configureLayout()
        configureColletionView()
    }
    
    
    func configureLayout() {
        
        view.addSubview(backButton)
        view.addSubview(midNavTitle)
        view.addSubview(cancelButton)
        let indicatorView = UIHostingController(rootView: IndicatorView(viewModel: self.viewModel))
        view.addSubview(indicatorView.view)
        view.addSubview(autoTextLabel)
        view.addSubview(toggleSwitch)
        view.addSubview(myTaminCollectionView)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        midNavTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        indicatorView.view.snp.makeConstraints {
            $0.top.equalTo(midNavTitle.snp.bottom).offset(34)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        autoTextLabel.snp.makeConstraints {
            $0.top.equalTo(indicatorView.view.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        toggleSwitch.snp.makeConstraints {
            $0.top.equalTo(indicatorView.view.snp.bottom).offset(30)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.width.equalTo(46)
            $0.height.equalTo(28)
        }
        
        myTaminCollectionView.snp.makeConstraints {
            $0.top.equalTo(toggleSwitch.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(142)
        }
        
    }

    func configureColletionView() {
        let flow = UICollectionViewFlowLayout()
        myTaminCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        myTaminCollectionView.register(MyTaminCollectionViewCell.self, forCellWithReuseIdentifier: MyTaminCollectionViewCell.cellId)
        myTaminCollectionView.delegate = self
        myTaminCollectionView.dataSource = self
        myTaminCollectionView.isScrollEnabled = false
    }

}

extension MyTaminViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTaminCollectionViewCell.cellId, for: indexPath) as? MyTaminCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}
