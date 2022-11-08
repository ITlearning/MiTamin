//
//  MyDayViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/10/24.
//

import UIKit
import SnapKit
import SwiftUI

enum ContentMode {
    case WishList
    case DayNote
}

class MyDayViewController: UIViewController, MenuBarDelegate {
    
    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    var editVC = EditWishListViewController()
    
    var contentMode: ContentMode = .DayNote
    
    var isDemmed: Bool = false
    
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

    
    let demmedView = UIView()
    
    var editView = UIView()
    
    var selectLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicBold(size: 18)
        label.text = "DJSakdjsakdha"
        return label
    }()
    
    var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("내용 수정하기", for: .normal)
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        
        return button
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(UIColor(rgb: 0xF04452), for: .normal)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "MyDayUpdate") {
            viewModel.getDayNoteList()
            UserDefaults.standard.set(false, forKey: "MyDayUpdate")
        }
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    let superDemmedView = DemmedView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationConfigure(title: "마이데이")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureMenuBar()
        configureCollectionView()
        configureLayout()
        viewModel.getWishList()
        viewModel.getDayNoteList()
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
                self.collectionView.reloadData()
                self.editVC.wishList = self.viewModel.wishList
            })
            .cancel(with: cancelBag)
        
        viewModel.$dayNoteList
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {_ in
                self.collectionView.reloadData()
            })
            .cancel(with: cancelBag)
        
        editButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.openSelectMenu()
                
                guard let cell = self.collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) else {
                    return
                }
                
                guard let cell = cell as? WishListCollectionViewCell else { return }
                
                cell.editMode = true
                
            })
            .cancel(with: cancelBag)
        
        deleteButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.openSelectMenu()
                guard let cell = self.collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) else {
                    return
                }
                
                guard let cell = cell as? WishListCollectionViewCell else { return }
                
                cell.deleteAction()
            })
            .cancel(with: cancelBag)
        
        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                if value {
                    self.superDemmedView.showDemmedPopup(text: "위시리스트를 등록중이에요!")
                } else {
                    self.superDemmedView.hide()
                }
            })
            .cancel(with: cancelBag)
    }
    
    func addDayNote() {
        let addVC = AddDayNoteViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    func moveToFAB() {
        if viewModel.wishList.isEmpty {
            let firstVC = FirstTypingViewController()
            firstVC.delegate = self
            self.navigationController?.pushViewController(firstVC, animated: true)
        }
    }
    
    @objc
    func editButtonAction() {
        editVC.delegate = self
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc
    func openSelectMenu() {
        if isDemmed {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                self.editView.snp.remakeConstraints {
                    $0.bottom.equalTo(self.view.snp.bottom).offset(204)
                    $0.leading.equalTo(self.view.snp.leading)
                    $0.width.equalTo(UIScreen.main.bounds.width)
                    $0.height.equalTo(204)
                }
                self.demmedView.backgroundColor = .black.withAlphaComponent(0.0)
                self.editView.superview?.layoutSubviews()
            }, completion: { _ in
                self.demmedView.isHidden = true
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                self.editView.snp.remakeConstraints {
                    $0.bottom.equalTo(self.view.snp.bottom)
                    $0.leading.equalTo(self.view.snp.leading)
                    $0.width.equalTo(UIScreen.main.bounds.width)
                    $0.height.equalTo(204)
                }
                self.demmedView.isHidden = false
                self.demmedView.backgroundColor = .black.withAlphaComponent(0.6)
                self.editView.superview?.layoutSubviews()
            })
        }
        isDemmed.toggle()
    }
    
    
    func configureLayout() {
        
        view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        demmedView.backgroundColor = .black.withAlphaComponent(0.0)
        demmedView.isHidden = true
        view.addSubview(demmedView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(openSelectMenu))
        
        demmedView.addGestureRecognizer(tap)
        
        demmedView.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top)
            $0.leading.equalTo(self.view.snp.leading)
            $0.trailing.equalTo(self.view.snp.trailing)
            $0.bottom.equalTo(self.view.snp.bottom)
        }
        
        let sepLine = UIView()
        sepLine.backgroundColor = UIColor(rgb: 0xEDEDED)
        view.addSubview(editView)
        editView.addSubview(editButton)
        editView.addSubview(selectLabel)
        editView.addSubview(sepLine)
        editView.addSubview(deleteButton)
        
        editView.clipsToBounds = true
        editView.layer.cornerRadius = 12
        editView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        editView.snp.makeConstraints {
            $0.bottom.equalTo(self.view.snp.bottom).offset(204)
            $0.leading.equalTo(self.view.snp.leading)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(204)
        }
        
        selectLabel.snp.makeConstraints {
            $0.top.equalTo(editView.snp.top).offset(24)
            $0.leading.equalTo(editView.snp.leading).offset(20)
        }
        editView.backgroundColor = .white

        editButton.snp.makeConstraints {
            $0.top.equalTo(selectLabel.snp.top).offset(32)
            $0.leading.equalTo(selectLabel.snp.leading)
        }
        
        sepLine.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom).offset(20)
            $0.leading.equalTo(selectLabel)
            $0.height.equalTo(1)
            $0.trailing.equalTo(self.view.snp.trailing).inset(20)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(sepLine.snp.bottom).offset(10)
            $0.leading.equalTo(selectLabel)
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
            contentMode = .DayNote
        } else {
            contentMode = .WishList
        }
        view.endEditing(true)
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
    
    func selectIndex(text: String, idx: Int) {
        selectLabel.text = text
        viewModel.selectIdx = idx
        openSelectMenu()
    }
}

extension MyDayViewController: DayNoteDeletgate {
    func selectIndexPath(indexPath: IndexPath) {
        let vc = DayNoteDetailViewController(dayNoteModel: viewModel.dayNoteList[indexPath.section].data[indexPath.row])
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension MyDayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayNoteCollectionViewCell.cellId, for: indexPath) as? DayNoteCollectionViewCell else { return UICollectionViewCell() }
            
            cell.dayNotes = viewModel.dayNoteList
            
            cell.delegate = self
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishListCollectionViewCell.cellId, for: indexPath) as? WishListCollectionViewCell else { return UICollectionViewCell() }
            
            cell.wishList = viewModel.wishList
            cell.delegate = self
            
            cell.setText(text: "자신을 위해서 해보고\n싶은 행동이 있나요?")
            
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
        
        floatingButton.alpha = ((scrollView.contentSize.width/2) - scrollView.contentOffset.x) / (scrollView.contentSize.width/2)
        
        menuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        
        if indexPath.row == 0 {
            contentMode = .DayNote
        } else {
            contentMode = .WishList
        }
        view.endEditing(true)
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
