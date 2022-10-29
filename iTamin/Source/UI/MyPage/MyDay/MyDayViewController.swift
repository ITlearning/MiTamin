//
//  MyDayViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/10/24.
//

import UIKit
import SnapKit

enum ContentMode {
    case WishList
    case DayNote
}

class MyDayViewController: UIViewController, MenuBarDelegate {
    
    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    var editVC = EditWishListViewController()
    
    var contentMode: ContentMode = .WishList
    
    var opacity: Float = 0.0
    
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
    
    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonAction))
        button.tintColor = UIColor.grayColor4
        return button
    }()
    
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
                switch self.contentMode {
                case .WishList:
                    self.moveToFAB()
                case .DayNote:
                    self.addDayNote()
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.$wishList
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                print("value,", value)
                self.collectionView.reloadData()
                self.editVC.wishList = self.viewModel.wishList
                if value.count > 0 {
                    self.floatingButton.alpha = 0.0
                    self.navigationItem.rightBarButtonItem = self.editButton
                } else {
                    self.floatingButton.alpha = 1.0
                    self.navigationItem.rightBarButtonItem = nil
                }
                
            })
            .cancel(with: cancelBag)
        
    }
    
    func addDayNote() {
        
    }
    
    func moveToFAB() {
        if viewModel.wishList.isEmpty {
            let firstVC = FirstTypingViewController()
            firstVC.delegate = self
            self.navigationController?.pushViewController(firstVC, animated: true)
        } else {
            
        }
    }
    
    @objc
    func editButtonAction() {
        editVC.delegate = self
        self.navigationController?.pushViewController(editVC, animated: true)
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
        
        if indexPath.row == 0 {
            contentMode = .WishList
            self.navigationItem.rightBarButtonItem = self.editButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
            contentMode = .DayNote
        }
        
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(WishListCollectionViewCell.self, forCellWithReuseIdentifier: WishListCollectionViewCell.cellId)
        collectionView.register(DayNoteCollectionViewCell.self, forCellWithReuseIdentifier: DayNoteCollectionViewCell.cellId)
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
    
    func deleteData(idx: Int) {
        viewModel.deleteWishList(idx: idx)
    }
    
}

extension MyDayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishListCollectionViewCell.cellId, for: indexPath) as? WishListCollectionViewCell else { return UICollectionViewCell() }
            
            cell.wishList = viewModel.wishList
            cell.delegate = self
            
            cell.setText(text: "자신을 위해서 해보고\n싶은 행동이 있나요?")
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayNoteCollectionViewCell.cellId, for: indexPath) as? DayNoteCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayNoteCollectionViewCell.cellId, for: indexPath) as? DayNoteCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !viewModel.wishList.isEmpty {
            floatingButton.alpha = scrollView.contentOffset.x / (scrollView.contentSize.width/2)
        }
        
        menuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        
        if indexPath.row == 0 {
            contentMode = .WishList
            self.navigationItem.rightBarButtonItem = self.editButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
            contentMode = .DayNote
        }
        
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
