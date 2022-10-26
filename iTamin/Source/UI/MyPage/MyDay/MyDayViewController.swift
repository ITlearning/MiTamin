//
//  MyDayViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/10/24.
//

import UIKit
import SnapKit

class MyDayViewController: UIViewController, MenuBarDelegate {
    
    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let floatingButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "FAB"), for: .normal)
        
        return button
    }()
    
    var menuBar = MenuBar()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        navigationConfigure(title: "마이데이")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureMenuBar()
        configureCollectionView()
        configureLayout()
        viewModel.getWishList()
        bindCombine()
    }
    
    func bindCombine() {
        floatingButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.moveToFAB()
            })
            .cancel(with: cancelBag)
        
        viewModel.$wishList
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                print("value,", value)
                self.collectionView.reloadData()
                
            })
            .cancel(with: cancelBag)
        
    }
    
    func moveToFAB() {
        if viewModel.wishList.isEmpty {
            let firstVC = FirstTypingViewController()
            firstVC.delegate = self
            self.navigationController?.pushViewController(firstVC, animated: true)
        } else {
            
        }
    }
    
    func configureLayout() {
        view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
    }
    
    func configureMenuBar() {
        view.addSubview(menuBar)
        menuBar.delegate = self
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.indicatorViewWidthConstraint.constant = self.view.frame.width/2
        menuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    
    func menuBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(WishListCollectionViewCell.self, forCellWithReuseIdentifier: WishListCollectionViewCell.cellId)
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(menuBar.snp.bottom)
        }
    }
}

extension MyDayViewController: CustomTextFieldDelegate {
    func sendToText(text: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.viewModel.addWishList(text: text)
        })
    }
}

extension MyDayViewController: WishListCollectionViewDelegate {
    func addData(text: String) {
        viewModel.addWishList(text: text)
    }
    
    func editData(item: WishListModel) {
        viewModel.editWishList(item: item)
    }
    
    func deleteData(item: WishListModel) {
        viewModel.deleteWishList(item: item)
    }
    
}

extension MyDayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishListCollectionViewCell.cellId, for: indexPath) as? WishListCollectionViewCell else { return UICollectionViewCell() }
        
        cell.wishList = viewModel.wishList
        cell.delegate = self
        
        if indexPath.row == 0 {
            cell.setText(text: "자신을 위해서 해보고\n싶은 행동이 있나요?")
        } else {
            cell.setText(text: "이번 마이데이에는\n어떤 추억을 쌓게 될까요?")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

extension MyDayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
