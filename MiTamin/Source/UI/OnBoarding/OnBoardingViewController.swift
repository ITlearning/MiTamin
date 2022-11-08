//
//  OnBoardingViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import UIKit
import SwiftUI
import Combine
import CombineCocoa
import SnapKit


class OnBoardingViewController: UIViewController {
    private var cancelBag = CancelBag()
    
    private var viewModel: SignUpViewModel
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        return collectionView
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.primaryColor
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 8
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        button.clipsToBounds = true
        
        return button
    }()
    
    let nextTimeButton: UIButton = {
        let button = UIButton()
        button.setTitle("나중에 할게요.", for: .normal)
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        button.titleLabel?.font = UIFont.SDGothicRegular(size: 16)
        button.isHidden = true
        return button
    }()
    
    private lazy var indicatorView = OnBoardingIndicator(viewModel: self.viewModel)
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureLayout()
        configureCollectionView()
        bindCombine()
    }

    func bindCombine() {
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if self.viewModel.currentIndex + 1 < 4 {
                    self.viewModel.currentIndex += 1
                    
                    self.collectionView.scrollToItem(at: IndexPath(item: self.viewModel.currentIndex, section: 0), at: .centeredVertically, animated: true)
                    withAnimation {
                        self.viewModel.index.send(self.viewModel.currentIndex)
                    }
                    self.setButtonText(index: self.viewModel.currentIndex)
                } else {
                    self.viewModel.signUpToServer(skip: false)
                }
            })
            .cancel(with: cancelBag)
        
        nextTimeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                if !self.viewModel.myTaminHour.isEmpty {
                    self.viewModel.myTaminHour = ""
                    self.viewModel.myTaminMin = ""
                }
                self.viewModel.signUpToServer(skip: true)
            })
            .cancel(with: cancelBag)
        viewModel.signUpSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .cancel(with: cancelBag)
    }
    
    
    func configureCollectionView() {
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.cellId)
        let collectionViewFlow = UICollectionViewFlowLayout()
        collectionViewFlow.minimumLineSpacing = 0
        collectionViewFlow.minimumInteritemSpacing = 0
        collectionViewFlow.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.collectionViewLayout = collectionViewFlow
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        viewModel.setDescription()
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        view.addSubview(nextTimeButton)
        let vc = UIHostingController(rootView: indicatorView)
        view.addSubview(vc.view)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(155)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(24)
            $0.height.equalTo(56)
        }
        
        nextTimeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(80)
            $0.centerX.equalToSuperview()
        }
        
        vc.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(64)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }
    
    func setButtonText(index: Int) {
        if index == 3 {
            nextTimeButton.isHidden = false
            nextButton.setTitle("시작하기", for: .normal)
        } else {
            nextTimeButton.isHidden = true
            nextButton.setTitle("다음", for: .normal)
        }
    }
    
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.cellId, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }
        let text = viewModel.descriptionArray[indexPath.row]
        if indexPath.row == 0 {
            let replace = text.replacingOccurrences(of: "|", with: viewModel.showUserName())
            viewModel.descriptionArray[indexPath.row] = replace
            cell.setCell(mainTitle: replace, image: viewModel.cellImages[indexPath.row])
        }
        
        if indexPath.row == 3 {
            cell.setHidden(hidden: false)
        } else {
            cell.setHidden(hidden: true)
        }
        
        cell.setCell(mainTitle: text, image: viewModel.cellImages[indexPath.row])
        
        cell.pickDate = { result in
            if self.viewModel.currentIndex == 3 {
                self.viewModel.myTaminHour = result.first ?? ""
                self.viewModel.myTaminMin = result.last ?? ""
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.descriptionArray.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        
        
        withAnimation {
            viewModel.currentIndex = indexPath.row
            self.viewModel.index.send(self.viewModel.currentIndex)
        }
        setButtonText(index: indexPath.row)
    }
}
