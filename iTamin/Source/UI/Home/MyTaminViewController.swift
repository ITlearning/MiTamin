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

enum CellType: CaseIterable {
    case myTaminOne
    case myTaminTwo
    case myTaminThreeOne
    case myTaminThreeTwo
    case myTaminThreeThree
    case myTaminFour
    
    init(_ idx: Int) {
        self = CellType.allCases[idx]
    }
}

class MyTaminViewController: UIViewController {
    
    var viewModel: ViewModel = ViewModel()
    
    var cancelBag = CancelBag()
    
    var index: Int = 0
    
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        return collectionView
    }()
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myTaminTimerBG")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let passButton: UIButton = {
        let button = UIButton()
        button.setTitle("패스하기", for: .normal)
        button.layer.borderColor = UIColor.primaryColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        button.setTitleColor(UIColor.primaryColor, for: .normal)
        
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음으로", for: .normal)
        button.setTitle("다음으로", for: .disabled)
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .disabled)
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.grayColor1
        button.isEnabled = false
        
        return button
    }()
    
    let bottomBarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bottomBar")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationConfigure(title: "오늘의 마이타민")
        view.backgroundColor = .white
        
        backButton.tapPublisher
            .sink(receiveValue: { _ in
                let currentIndex = self.viewModel.myTaminStatus.value
                guard currentIndex - 1 > 0 else { return }
                self.viewModel.myTaminStatus.send(currentIndex-1)
                self.scrollToIndex(index: self.viewModel.myTaminStatus.value-1)
                self.nextButtonAction(index: self.viewModel.myTaminStatus.value-1)
                self.resetView(index: self.viewModel.myTaminStatus.value-1)
            })
            .cancel(with: cancelBag)
        
        cancelButton.tapPublisher
            .sink(receiveValue: { _ in
                self.dismiss(animated: true)
            })
            .cancel(with: cancelBag)
        
        passButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                if self.viewModel.myTaminStatus.value < self.viewModel.myTaminModel.count {
                    let currentIndex = self.viewModel.myTaminStatus.value
                    self.viewModel.myTaminStatus.send(currentIndex+1)
                    self.scrollToIndex(index: self.viewModel.myTaminStatus.value-1)
                    self.nextButtonAction(index: self.viewModel.myTaminStatus.value-1)
                    self.resetCell(idx: currentIndex)
                    self.resetView(index: currentIndex)
                }
            })
            .cancel(with: cancelBag)
        
        
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                if self.viewModel.myTaminStatus.value < self.viewModel.myTaminModel.count {
                    let currentIndex = self.viewModel.myTaminStatus.value
                    self.viewModel.myTaminStatus.send(currentIndex+1)
                    self.scrollToIndex(index: self.viewModel.myTaminStatus.value-1)
                    self.nextButtonAction(index: self.viewModel.myTaminStatus.value-1)
                }
            })
            .cancel(with: cancelBag)
        
        configureLayout()
        configureColletionView()
    }
    
    
    func resetView(index: Int) {
        let type = CellType(index)
        print(type)
        switch type {
        case .myTaminOne,.myTaminTwo:
            
            UIView.animate(withDuration: 0.2, animations: {
                self.autoTextLabel.alpha = 1.0
                self.toggleSwitch.alpha = 1.0
                self.backgroundImage.alpha = 1.0
            }, completion: { _ in
                self.autoTextLabel.isHidden = false
                self.toggleSwitch.isHidden = false
            })
            
            
            collectionView.snp.makeConstraints {
                $0.top.equalTo(toggleSwitch.snp.bottom).offset(20)
                $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
                $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(142)
            }
            
        case .myTaminThreeOne,.myTaminThreeTwo,.myTaminThreeThree,.myTaminFour:
            
            UIView.animate(withDuration: 0.2, animations: {
                self.autoTextLabel.alpha = 0.0
                self.toggleSwitch.alpha = 0.0
                self.backgroundImage.alpha = 0.0
            }, completion: { _ in
                self.autoTextLabel.isHidden = true
                self.toggleSwitch.isHidden = true
            })
            
            collectionView.snp.remakeConstraints {
                $0.top.equalTo(toggleSwitch.snp.bottom).offset(-28)
                $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
                $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(142)
            }
        }
    }
    
    
    func configureLayout() {
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(midNavTitle)
        view.addSubview(cancelButton)
        let indicatorView = UIHostingController(rootView: IndicatorView(viewModel: self.viewModel))
        view.addSubview(indicatorView.view)
        view.addSubview(autoTextLabel)
        view.addSubview(toggleSwitch)
        view.addSubview(collectionView)
        view.addSubview(bottomBarImage)
        view.addSubview(nextButton)
        view.addSubview(passButton)
        
        backgroundImage.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(15)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(77)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(160)
            $0.height.equalTo(432)
        }
        
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(toggleSwitch.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(142)
        }
        
        bottomBarImage.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        passButton.snp.makeConstraints {
            $0.top.equalTo(bottomBarImage.snp.top).offset(12)
            $0.leading.equalTo(bottomBarImage.snp.leading).offset(25)
            $0.width.equalTo(162)
            $0.height.equalTo(56)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(bottomBarImage.snp.top).offset(12)
            $0.trailing.equalTo(bottomBarImage.snp.trailing).inset(25)
            $0.width.equalTo(162)
            $0.height.equalTo(56)
        }
    }

    func configureColletionView() {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        collectionView.register(MyTaminCollectionViewCell.self, forCellWithReuseIdentifier: MyTaminCollectionViewCell.cellId)
        collectionView.register(MindCollectionViewCell.self, forCellWithReuseIdentifier: MindCollectionViewCell.cellId)
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = flow
        
        collectionView.setCollectionViewLayout(flow, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
    }

    func resetCell(idx: Int) {
        guard let cell = self.collectionView.cellForItem(at: IndexPath(row: idx, section: 0)) else {
            return
        }
        guard let cell = cell as? MyTaminCollectionViewCell else { return }
        //cell.startOtpTimer()
        cell.timerStatus = .pause
        cell.restartButton()
    }
    
    
    func nextButtonAction(index: Int) {
        
        let isDone = viewModel.myTaminModel[index].isDone
        
        if isDone {
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = UIColor.primaryColor
        } else {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.grayColor1
        }
        
    }
    
    func scrollToIndex(index:Int) {
        let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 0))?.frame
        self.collectionView.scrollRectToVisible(rect!, animated: true)
        
        if toggleSwitch.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                guard let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) else {
                    return
                }
                guard let cell = cell as? MyTaminCollectionViewCell else { return }
                cell.startOtpTimer()
            })
        }
    }
    
    
    func checkToServer(idx: Int) {
        switch idx {
        case 0:
            viewModel.breathSuccess()
        case 1:
            viewModel.senseSuccess()
        default:
            break
        }
    }
    
}

extension MyTaminViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            viewModel.myTaminStatus.send((indexPath?.row ?? 0)+1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.myTaminModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = viewModel.myTaminModel[indexPath.row]
        
        let type = CellType(indexPath.row)
        
        
        switch type {
        case .myTaminOne, .myTaminTwo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTaminCollectionViewCell.cellId, for: indexPath) as? MyTaminCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(index: indexPath.row, model: model)
            
            cell.nextOn = {
                self.viewModel.myTaminModel[indexPath.row].isDone = true
                self.checkToServer(idx: indexPath.row)
                if self.toggleSwitch.isOn {
                    if indexPath.row < self.viewModel.myTaminModel.count {
                        self.scrollToIndex(index: indexPath.row+1)
                    }
                } else {
                    self.nextButtonAction(index: indexPath.row)
                }
                
            }
            
            return cell
        case .myTaminThreeOne:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MindCollectionViewCell.cellId, for: indexPath) as? MindCollectionViewCell else { return UICollectionViewCell() }
            
            cell.buttonClick = { idx in
                print("마이타민 뷰 컨 전송",idx)
            }
            
            return cell
//        case .myTaminThreeTwo:
//        case .myTaminThreeThree:
//            <#code#>
//        case .myTaminFour:
//            <#code#>
        default:
            break
        }
        
        
        return UICollectionViewCell()
    }
    
    
}
