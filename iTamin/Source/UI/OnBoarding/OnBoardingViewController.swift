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
        button.backgroundColor = UIColor.buttonDone
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 8
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.notoMedium(size: 18)
        button.clipsToBounds = true
        
        return button
    }()
    
    let nextTimeButton: UIButton = {
        let button = UIButton()
        button.setTitle("나중에 할게요.", for: .normal)
        button.setTitleColor(UIColor.nextTimeGray, for: .normal)
        button.titleLabel?.font = UIFont.notoRegular(size: 16)
        return button
    }()
    
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
        configureLayout()
        configureCollectionView()
        bindCombine()
    }

    func bindCombine() {
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if self.viewModel.currentInex + 1 < 4 {
                    self.viewModel.currentInex += 1
                }
                self.collectionView.scrollToItem(at: IndexPath(item: self.viewModel.currentInex, section: 0), at: .centeredVertically, animated: true)
            })
            .cancel(with: cancelBag)
        
        nextTimeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.viewModel.signUpToServer()
            })
            .cancel(with: cancelBag)
        
        viewModel.signUpSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                //UserDefaults.standard.set(true, forKey: "isLogined")
                //self.moveToMain()
                self.dismiss(animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(155)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(150)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(24)
            $0.height.equalTo(56)
        }
        
        nextTimeButton.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).inset(26)
            $0.centerX.equalToSuperview()
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
            cell.setCell(mainTitle: replace, image: "Mainillustration")
        }
        
        cell.setCell(mainTitle: text, image: "Mainillustration")
        
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
        
        viewModel.currentInex = indexPath.row
    }
}
