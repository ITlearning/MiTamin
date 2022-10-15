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
    var categoryViewModel = CategoryCollectionViewModel()
    var viewModel: ViewModel = ViewModel()
    var cancelBag = CancelBag()
    
    let index: Int
    
    init(index: Int) {
        self.index = index != 3 ? index : index + 2
        self.viewModel.currentIndex = index != 3 ? index : index + 2
        self.viewModel.myTaminStatus.send(index + 1)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationConfigure(title: "오늘의 마이타민")
        view.backgroundColor = .white
        
        
        bindCombine()
        configureColletionView()
        configureLayout()
        self.hideKeyboardWhenTappedAround()
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
                self.dismiss(animated: true)
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
            .sink(receiveValue: { _ in
                if self.viewModel.currentIndex < self.viewModel.myTaminModel.count - 1 {
                    self.controlIndex()
                    self.scrollToIndex(index: self.viewModel.currentIndex)
                    self.nextButtonAction(index: self.viewModel.currentIndex)
                } else {
                    self.viewModel.sendCareDailyReport()
                    self.dismiss(animated: true)
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.selectMindTexts.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.nextButtonAction(index: self.viewModel.currentIndex)
            })
            .cancel(with: cancelBag)
    }
    
    
    func resetView(index: Int) {
        let type = CellType(index)
        switch type {
        case .myTaminOne,.myTaminTwo:
            UIView.animate(withDuration: 0.2, animations: {
                self.autoTextLabel.alpha = 1.0
                self.toggleSwitch.alpha = 1.0
                self.backgroundImage.alpha = 1.0
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
                self.backgroundImage.alpha = 0.0
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
                viewModel.sendDailyReport()
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
        collectionView.register(MindTextCollectionViewCell.self, forCellWithReuseIdentifier: MindTextCollectionViewCell.cellId)
        collectionView.register(TextViewCollectionViewCell.self, forCellWithReuseIdentifier: TextViewCollectionViewCell.cellId)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.cellId)
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = flow
        
        collectionView.setCollectionViewLayout(flow, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
            self.collectionView.isScrollEnabled = false
            self.collectionView.scrollToItem(at: IndexPath(item: self.viewModel.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            self.collectionView.isScrollEnabled = true
            self.resetView(index: self.viewModel.currentIndex)
            
            if self.viewModel.myTaminStatus.value == 4 {
                self.nextButton.setTitle("섭취완료!", for: .normal)
                self.nextButton.setTitle("섭취완료!", for: .disabled)
                
            }
            
        })
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
    
    func setMindTextData(idx: Int) {
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
            })
        }
    }
    
    func checkIsDone(bool: Bool) {
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
            self.checkIsDone(bool: true)
            self.nextButtonAction(index: self.viewModel.currentIndex)
            nav.dismiss(animated: true)
        }
        
        present(nav, animated: true)
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
            
            cell.configureCell(index: indexPath.row, model: model)
            
            cell.nextOn = {
                self.viewModel.myTaminModel[indexPath.row].isDone = true
                self.passButton.isEnabled = true
                self.passButtonSet()
                self.checkToServer(idx: indexPath.row)
                if self.toggleSwitch.isOn {
                    if indexPath.row < self.viewModel.myTaminModel.count {
                        self.scrollToIndex(index: indexPath.row+1)
                    }
                } else {
                    self.nextButtonAction(index: indexPath.row)
                }
            }
            
            cell.buttonStatus = { value in
                if value == .pause {
                    self.passButton.isEnabled = true
                    self.passButtonSet()
                } else {
                    self.passButton.isEnabled = false
                    self.passButtonSet()
                }
            }
            
            return cell
        case .myTaminThreeOne:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MindCollectionViewCell.cellId, for: indexPath) as? MindCollectionViewCell else { return UICollectionViewCell() }
            
            cell.buttonClick = {  [weak self] idx in
                guard let self = self else { return }
                self.checkIsDone(bool: true)
                self.nextButtonAction(index: self.viewModel.currentIndex)
                self.viewModel.selectMindIndex.send(idx)
                self.setMindTextData(idx: idx)
                self.viewModel.selectMindTexts.send([])
                self.setMindTextSelectData()
            }
            
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
                if texts.count == 3 {
                    self.checkIsDone(bool: true)
                } else {
                    self.checkIsDone(bool: false)
                }
                
            }
            
            return cell
        case .myTaminThreeThree:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextViewCollectionViewCell.cellId, for: indexPath) as? TextViewCollectionViewCell else { return UICollectionViewCell() }
            
            cell.textView.delegate = self
            
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
