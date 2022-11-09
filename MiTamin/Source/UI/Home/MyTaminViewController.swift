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

extension MyTaminViewController {
    func getIsDoneStatus(idx: Int) -> Bool {
        print("Done Status",idx)
        switch idx {
        case 3:
            return UserDefaults.standard.bool(forKey: .reportIsDone)
        case 4:
            return UserDefaults.standard.bool(forKey: .careIsDone)
        default:
            return false
        }
    }
}

class MyTaminViewController: UIViewController {
    var mindSelectViewModel = MindSelectViewModel()
    var categoryViewModel = CategoryCollectionViewModel()
    var viewModel: ViewModel = ViewModel()
    var cancelBag = CancelBag()
    
    let index: Int
    var isDone: Bool = false
    
    init(index: Int) {
        
        if index == 2 {
            self.viewModel.myTaminStatus.send(3)
            self.index = index
            self.viewModel.currentIndex = index
        } else if index == 3 {
            self.index = 5
            self.viewModel.currentIndex = 5
            self.viewModel.myTaminStatus.send(4)
        } else {
            self.viewModel.myTaminStatus.send(index+1)
            self.index = index
            self.viewModel.currentIndex = index
        }
        super.init(nibName: nil, bundle: nil)
        //self.isDone = self.getIsDoneStatus(idx: self.viewModel.myTaminStatus.value)
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
        toggle.tintColor = UIColor(rgb: 0xFFEB85)
        toggle.onTintColor = UIColor(rgb: 0xFFEB85)
        return toggle
    }()
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        return collectionView
    }()
    
    let passButton: UIButton = {
        let button = UIButton()
        button.setTitle("패스하기", for: .normal)
        button.setTitle("패스하기", for: .disabled)
        button.layer.borderColor = UIColor.primaryColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        button.setTitleColor(UIColor.primaryColor, for: .normal)
        button.setTitleColor(UIColor.grayColor1, for: .disabled)
        
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
    
    let blackView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor.black
        bView.alpha = 0.0
        return bView
    }()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "데이터를 불러오는 중이에요..!"
        label.font = UIFont.SDGothicBold(size: 15)
        label.alpha = 0.0
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var alertView = UIHostingController(rootView: AlertView(viewModel: self.viewModel))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        
        bindCombine()
        configureColletionView()
        configureLayout()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func bindCombine() {
        backButton.tapPublisher
            .sink(receiveValue: { _ in
                if self.viewModel.currentIndex - 1 > -1 {
                    self.controlIndex(back: true)
                    self.scrollToIndex(index: self.viewModel.currentIndex)
                    self.nextButtonAction(index: self.viewModel.currentIndex)
                    self.resetView(index: self.viewModel.currentIndex)
                }
            })
            .cancel(with: cancelBag)
        
        cancelButton.tapPublisher
            .sink(receiveValue: { _ in
                switch self.viewModel.currentIndex {
                case 0,1:
                    guard let cell = self.collectionView.cellForItem(at: IndexPath(row: self.viewModel.currentIndex, section: 0)) else {
                        return
                    }
                    guard let cell = cell as? MyTaminCollectionViewCell else { return }
                    //cell.startOtpTimer()
                    print(cell.timerStatus)
                    if cell.timerStatus == .start {
                        self.dismissAlert()
                    } else {
                        self.dismiss(animated: true)
                    }
                case 2:
                    if self.nextButton.isEnabled == true {
                        self.dismissAlert()
                    } else {
                        self.dismiss(animated: true)
                    }
                case 5:
                    if self.categoryViewModel.text != "카테고리를 골라주세요." {
                        self.dismissAlert()
                    } else {
                        self.dismiss(animated: true)
                    }
                default:
                    self.dismiss(animated: true)
                }
            })
            .cancel(with: cancelBag)
        
        passButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                if self.viewModel.currentIndex+1 < self.viewModel.myTaminModel.count {
                    self.controlIndex()
                    self.scrollToIndex(index: self.viewModel.currentIndex)
                    self.nextButtonAction(index: self.viewModel.currentIndex)
                    self.resetCell(idx: self.viewModel.currentIndex)
                    self.resetView(index: self.viewModel.currentIndex)
                }
            })
            .cancel(with: cancelBag)
        
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if self.viewModel.currentIndex < self.viewModel.myTaminModel.count - 1 {
                    self.controlIndex()
                    self.scrollToIndex(index: self.viewModel.currentIndex)
                    self.nextButtonAction(index: self.viewModel.currentIndex)
                } else {
                    if UserDefaults.standard.bool(forKey: .careIsDone) {
                        self.viewModel.editCareReport()
                        UserDefaults.standard.set(true, forKey: "updateData")
                    } else {
                        UserDefaults.standard.set(true, forKey: "updateData")
                        self.viewModel.sendCareDailyReport()
                    }
                    self.dismiss(animated: true)
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.selectCategoryIdx.receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                if value != -1 {
                    self.categoryViewModel.text = self.viewModel.selectMindArray[value]
                }
            })
            .cancel(with: cancelBag)
        
        
        viewModel.selectMindTexts.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                if !value.isEmpty {
                    self.nextButtonAction(index: self.viewModel.currentIndex)
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.myTaminStatus
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                self.isDone = self.getIsDoneStatus(idx: value)
                if self.getIsDoneStatus(idx: value) && (self.viewModel.currentIndex == 2 || self.viewModel.currentIndex == 5) {
                    self.viewModel.isEditStatus.send(true)
                    self.viewModel.alertText = self.viewModel.currentIndex == 2 ? "하루 진단하기" : "칭찬 처방하기"
                    self.showBlackAnimate()
                    DispatchQueue.main.async {
                        self.alertView.view.alpha = 1.0
                    }
                    
                } else {
                    self.viewModel.isEditStatus.send(false)
                    self.alertView.view.alpha = 0.0
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.isEditStatus
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                DispatchQueue.main.async {
                    self.alertView.view.alpha = value ? 1.0 : 0.0
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.selectMindIndex
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                if value != -1 {
                    self.checkIsDone(bool: true)
                }
                
                if value < 0 {
                    self.mindSelectViewModel.index = 0
                } else {
                    self.mindSelectViewModel.index = value
                }
                
            })
            .cancel(with: cancelBag)
        
        viewModel.dataIsReady
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                if value {
                    if self.viewModel.currentIndex == 5 {
                        self.setCareReportData()
                    }
                    self.hideBlackAnimate()
                } else {
                    self.showBlackAnimate()
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.selectMindTexts
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                if !value.isEmpty {
                    self.setMindTextData()
                    self.checkIsDone(bool: true)
                }
            })
            .cancel(with: cancelBag)
        
    }
    
    func dismissAlert() {
        var description: String = ""
        switch self.viewModel.currentIndex {
        case 0:
            description = "숨고르기를 그만하고 나가시겠어요?\n진행시간은 저장되지 않습니다."
        case 1:
            description = "감각 깨우기를 그만하고 나가시겠어요?\n진행시간은 저장되지 않습니다."
        case 2:
            description = "하루 진단하기를 그만하고 나가시겠어요?\n진단 중이었던 내용은 저장되지 않습니다."
        case 5:
            description = "칭찬 처방하기를 그만하고 나가시겠어요?\n칭찬 중이었던 내용은 저장되지 않습니다."
        default:
            break
        }
        
        let alertView = UIAlertController(title: "나가기", message: description, preferredStyle: .alert)
        
        let done = UIAlertAction(title: "취소", style: .cancel)
        
        let exit = UIAlertAction(title: "나가기", style: .destructive, handler: { _ in
            self.dismiss(animated: true)
        })
        
        alertView.addAction(done)
        alertView.addAction(exit)
        
        self.present(alertView, animated: true)
        
        
    }
    
    func showBlackAnimate() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0.2
            self.loadingLabel.alpha = 1.0
        })
    }
    
    func hideBlackAnimate() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0.0
            self.loadingLabel.alpha = 0.0
        })
    }
    
    
    func setCareReportData() {
        guard let cell = self.collectionView.cellForItem(at: IndexPath(row: 5, section: 0)) else {
            return
        }
        guard let cell = cell as? CategoryCollectionViewCell else { return }
        
        cell.textView.text = viewModel.mainTextViewData.value
        cell.textView.textColor = .black
        cell.subTextView.text = viewModel.subTextViewData.value
        cell.subTextView.textColor = .black
    }
    
    func resetView(index: Int) {
        let type = CellType(index)
        switch type {
        case .myTaminOne,.myTaminTwo:
            UIView.animate(withDuration: 0.2, animations: {
                self.autoTextLabel.alpha = 1.0
                self.toggleSwitch.alpha = 1.0
                self.passButton.alpha = 1.0
                
                self.collectionView.snp.makeConstraints {
                    $0.top.equalTo(self.toggleSwitch.snp.bottom).offset(20)
                    $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
                    $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(20)
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(142)
                }
                self.collectionView.superview?.layoutIfNeeded()
                
                self.passButton.snp.remakeConstraints {
                    $0.top.equalTo(self.bottomBarImage.snp.top).offset(12)
                    $0.leading.equalTo(self.bottomBarImage.snp.leading).offset(25)
                    $0.width.equalTo(162)
                    $0.height.equalTo(56)
                }
                
                self.passButton.superview?.layoutIfNeeded()
                
                self.nextButton.snp.remakeConstraints {
                    $0.top.equalTo(self.bottomBarImage.snp.top).offset(12)
                    $0.trailing.equalTo(self.bottomBarImage.snp.trailing).inset(25)
                    $0.width.equalTo(162)
                    $0.height.equalTo(56)
                }
                
                self.nextButton.superview?.layoutIfNeeded()
                
            }, completion: { _ in
                self.autoTextLabel.isHidden = false
                self.toggleSwitch.isHidden = false
            })
            
        case .myTaminThreeOne,.myTaminThreeTwo,.myTaminThreeThree,.myTaminFour:
            
            UIView.animate(withDuration: 0.2, animations: {
                self.autoTextLabel.alpha = 0.0
                self.toggleSwitch.alpha = 0.0
                self.passButton.alpha = 0.0
                
                self.collectionView.snp.remakeConstraints {
                    $0.top.equalTo(self.toggleSwitch.snp.bottom).offset(-28)
                    $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
                    $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(20)
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(142)
                }
                
                self.collectionView.superview?.layoutIfNeeded()
                
                self.passButton.snp.remakeConstraints {
                    $0.top.equalTo(self.bottomBarImage.snp.top).offset(12)
                    $0.leading.equalTo(self.bottomBarImage.snp.leading).offset(25)
                    $0.width.equalTo(0)
                    $0.height.equalTo(56)
                }
                
                self.passButton.superview?.layoutIfNeeded()
                
                self.nextButton.snp.remakeConstraints {
                    $0.top.equalTo(self.bottomBarImage.snp.top).offset(12)
                    $0.trailing.equalTo(self.bottomBarImage.snp.trailing).inset(25)
                    $0.width.equalTo(162 + 162 + 20)
                    $0.height.equalTo(56)
                }
                
                self.nextButton.superview?.layoutIfNeeded()
                
            }, completion: { _ in
                self.autoTextLabel.isHidden = true
                self.toggleSwitch.isHidden = true
            })
            
        }
    }
    
    func passButtonSet() {
        if passButton.isEnabled {
            passButton.layer.borderColor = UIColor.primaryColor.cgColor
            passButton.layer.borderWidth = 1
            passButton.layer.cornerRadius = 8
        } else {
            passButton.layer.borderColor = UIColor.grayColor1.cgColor
            passButton.layer.borderWidth = 1
            passButton.layer.cornerRadius = 8
        }
    }
    
    func controlIndex(back: Bool = false) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            viewModel.currentIndex = back ? (indexPath?.row ?? 0) - 1 : (indexPath?.row ?? 0) + 1
            let type = CellType(back ? (indexPath?.row ?? 0) - 1 : (indexPath?.row ?? 0) + 1)
            
            switch type {
            case .myTaminOne:
                viewModel.myTaminStatus.send(1)
            case .myTaminTwo:
                viewModel.myTaminStatus.send(2)
            case .myTaminThreeOne, .myTaminThreeTwo, .myTaminThreeThree:
                viewModel.myTaminStatus.send(3)
            case .myTaminFour:
                if UserDefaults.standard.bool(forKey: .reportIsDone) {
                    viewModel.editDailyReport()
                    UserDefaults.standard.set(true, forKey: "updateData")
                } else {
                    viewModel.sendDailyReport()
                }
                viewModel.myTaminStatus.send(4)
            }
            
            switch type {
            case .myTaminOne,.myTaminTwo,.myTaminThreeOne,.myTaminThreeTwo,.myTaminThreeThree:
                nextButton.setTitle("다음으로", for: .normal)
                nextButton.setTitle("다음으로", for: .disabled)
            case .myTaminFour:
                nextButton.setTitle("섭취완료!", for: .normal)
                nextButton.setTitle("섭취완료!", for: .disabled)
            }
        }
    }
    
    func configureLayout() {
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
        view.addSubview(blackView)
        view.addSubview(loadingLabel)
        view.addSubview(self.alertView.view)
        
        self.loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        self.alertView.view.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(36)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(36)
        }
        
        blackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        self.alertView.rootView.cancelButtonAction = {
            self.dismiss(animated: true)
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
        collectionView.register(MindTextCollectionViewCell.self, forCellWithReuseIdentifier: MindTextCollectionViewCell.cellId)
        collectionView.register(TextViewCollectionViewCell.self, forCellWithReuseIdentifier: TextViewCollectionViewCell.cellId)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.cellId)
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = flow
        
        collectionView.setCollectionViewLayout(flow, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.collectionView.isScrollEnabled = false
            self.collectionView.scrollToItem(at: IndexPath(item: self.viewModel.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            self.resetView(index: self.viewModel.currentIndex)
            if self.viewModel.myTaminStatus.value == 4 {
                self.nextButton.setTitle("섭취완료!", for: .normal)
                self.nextButton.setTitle("섭취완료!", for: .disabled)
                
            }
            
        })
    }
    
    
    
    func setReportText() {
        guard let cell = self.collectionView.cellForItem(at: IndexPath(row: 4, section: 0)) else {
            return
        }
        
        guard let cell = cell as? TextViewCollectionViewCell else { return }
        cell.textView.text = viewModel.dailyReportData.value
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
    
    func setMindTextData() {
        guard let cell = self.collectionView.cellForItem(at: IndexPath(row: 3, section: 0)) else {
            return
        }
        guard let cell = cell as? MindTextCollectionViewCell else { return }
        
        cell.cellData = viewModel.showMindSet(idx: viewModel.selectMindIndex.value)
        
    }
    
    func setMindTextSelectData() {
        guard let cell = self.collectionView.cellForItem(at: IndexPath(row: 3, section: 0)) else {
            return
        }
        guard let cell = cell as? MindTextCollectionViewCell else { return }
        
        cell.selectCellTexts.removeAll()
    }
    
    func nextButtonAction(index: Int) {
        
        print("들어온 인덱스", index)
        print("현재 인덱스", viewModel.currentIndex)
        
        if index == viewModel.currentIndex {
            let isDone = viewModel.myTaminModel[index].isDone
            print("isDOne?", isDone)
            if isDone {
                self.nextButton.isEnabled = true
                self.nextButton.backgroundColor = UIColor.primaryColor
            } else {
                self.nextButton.isEnabled = false
                self.nextButton.backgroundColor = UIColor.grayColor1
            }
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
                self.viewModel.myTaminStatus.send(index)
            })
        }
    }
    
    func checkIsDone(bool: Bool) {
        print("Check Is BOol", bool)
        viewModel.myTaminModel[viewModel.currentIndex].isDone = bool
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
    
    func presentModal() {
        let categoryBottomSheetView = UIHostingController(rootView: CategoryBottomSheetView())
        
        let nav = UINavigationController(rootViewController: categoryBottomSheetView)
        
        nav.modalPresentationStyle = .pageSheet
        nav.isNavigationBarHidden = true
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        categoryBottomSheetView.rootView.buttonTouch = { text, idx in
            self.categoryViewModel.text = text
            self.viewModel.selectMindIndex.send(idx)
            self.viewModel.selectCategoryIdx.send(idx)
            self.checkIsDone(bool: true)
            self.nextButtonAction(index: self.viewModel.currentIndex)
            nav.dismiss(animated: true)
        }
        
        present(nav, animated: true)
    }
}

extension MyTaminViewController: MyTaminCollectionViewDelegate {
    func buttonClick(idx: Int) {
          self.checkIsDone(bool: true)
          self.nextButtonAction(index: self.viewModel.currentIndex)
          self.viewModel.selectMindIndex.send(idx)
          self.setMindTextData()
          self.viewModel.selectMindTexts.send([])
          self.setMindTextSelectData()
    }
    
    func buttonStatus(timer: TimerStatus) {
        if timer == .pause {
            self.passButton.isEnabled = true
            self.passButtonSet()
        } else {
            self.passButton.isEnabled = false
            self.passButtonSet()
        }
    }
    
    func nextOn() {
        for cell in collectionView.visibleCells {
            UserDefaults.standard.set(true, forKey: "updateData")
            guard let indexPath = collectionView.indexPath(for: cell) else { return }
            self.viewModel.myTaminModel[indexPath.row].isDone = true
            self.passButton.isEnabled = true
            self.passButtonSet()
            self.checkToServer(idx: indexPath.row)
            if self.toggleSwitch.isOn {
                if indexPath.row < self.viewModel.myTaminModel.count {
                    self.scrollToIndex(index: indexPath.row+1)
                    self.viewModel.myTaminStatus.send(indexPath.row + 1)
                }
            } else {
                self.nextButtonAction(index: indexPath.row)
            }
        }
    }
}

extension MyTaminViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            
            cell.delegate = self
            cell.configureCell(index: indexPath.row, model: model)
            
            return cell
        case .myTaminThreeOne:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MindCollectionViewCell.cellId, for: indexPath) as? MindCollectionViewCell else { return UICollectionViewCell() }
            
            cell.viewModel = mindSelectViewModel
            cell.delegate = self
            
            return cell
        case .myTaminThreeTwo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MindTextCollectionViewCell.cellId, for: indexPath) as? MindTextCollectionViewCell else { return UICollectionViewCell() }
            
            cell.cellData = viewModel.showMindSet(idx: viewModel.selectMindIndex.value)
            cell.selectCellTexts = viewModel.selectMindTexts.value
            cell.addAction = { value in
                self.viewModel.appendMindSet(idx: self.viewModel.selectMindIndex.value, value: value)
            }
            
            cell.selectCell = { [weak self] texts in
                guard let self = self else { return }
                self.viewModel.selectMindTexts.send(texts)
                if texts.count > 0 {
                    self.checkIsDone(bool: true)
                } else {
                    self.checkIsDone(bool: false)
                }
                
            }
            
            return cell
        case .myTaminThreeThree:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextViewCollectionViewCell.cellId, for: indexPath) as? TextViewCollectionViewCell else { return UICollectionViewCell() }
            
            cell.textView.delegate = self
            cell.textView.text = self.viewModel.dailyReportData.value
            cell.textView.textColor = self.viewModel.dailyReportData.value.isEmpty ? UIColor.grayColor5 : .black
            
            cell.textView.textPublisher
                .receive(on: RunLoop.main)
                .sink(receiveValue: { text in
                    if text?.isEmpty ?? true {
                        self.checkIsDone(bool: false)
                    } else {
                        if self.viewModel.placeHolder.contains(where: { $0 == text ?? "" }) {
                            self.checkIsDone(bool: false)
                        } else {
                            self.checkIsDone(bool: true)
                        }
                    }
                    self.viewModel.dailyReportData.send(text ?? "")
                    self.nextButtonAction(index: self.viewModel.currentIndex)
                })
                .cancel(with: cancelBag)
            
            return cell
        case .myTaminFour:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.cellId, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.viewModel = categoryViewModel
            cell.textView.text = viewModel.mainTextViewData.value
            cell.subTextView.text = viewModel.subTextViewData.value
            
            cell.tapCategory = {
                self.presentModal()
            }
            
            cell.textView.delegate = self
            cell.subTextView.delegate = self
            
            cell.textView.textPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { text in
                    if self.viewModel.placeHolder.contains(where: { $0 != text ?? "" }) {
                        self.checkIsDone(bool: true)
                        self.viewModel.mainTextViewData.send(text ?? "")
                        self.nextButtonAction(index: indexPath.row)
                    }
                    
                })
                .cancel(with: cancelBag)
            
            cell.subTextView.textPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { text in
                    
                    if self.viewModel.placeHolder.contains(where: { $0 != text ?? "" }) {
                        self.checkIsDone(bool: true)
                        self.viewModel.subTextViewData.send(text ?? "")
                        self.nextButtonAction(index: indexPath.row)
                    }
                })
                .cancel(with: cancelBag)
            
            return cell
        }
    }
    
    
}

extension MyTaminViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if viewModel.placeHolder.contains(where: { $0 == textView.text }) {
            textView.text = nil
            textView.textColor = .black
        }
    }
}
