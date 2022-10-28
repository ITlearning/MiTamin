//
//  EditWishListViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/10/28.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class EditWishListViewController: UIViewController {

    weak var delegate: WishListCollectionViewDelegate?
    
    private let tableView = UITableView()
    
    var wishList: [WishListModel] = [] {
        didSet {
            isEditIndex = -1
            tableView.reloadData()
        }
    }
    
    var deleteWishList: [Int] = []
    
    var cancelBag = CancelBag()
    
    var isEditIndex = -1
    
    var deleteMode: Bool = false
    
    private let currentLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 리스트"
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = UIColor.grayColor4
        label.isHidden = false
        return label
    }()
    
    private let selectDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택삭제", for: .normal)
        button.titleLabel?.font = UIFont.SDGothicMedium(size: 14)
        button.setTitleColor(UIColor.grayColor8, for: .normal)
        
        return button
    }()

    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "trash-2"), style: .plain, target: self, action: #selector(activeDeleteMode))
        button.tintColor = UIColor.grayColor4
        return button
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.backgroundColor = UIColor.grayColor7
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.SDGothicMedium(size: 16)
        button.isHidden = true
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        navigationConfigure(title: "리스트 편집")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = deleteButton
        view.backgroundColor = .white
        configureLayout()
        configureTableView()
        bindCombine()
    }
    
    func bindCombine() {
        doneButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.activeDeleteMode()
            })
            .cancel(with: cancelBag)
    }
    
    @objc
    func activeDeleteMode() {
        deleteMode.toggle()
        if deleteMode {
            self.navigationItem.rightBarButtonItem = nil
            doneButton.isHidden = false
        } else {
            doneButton.isHidden = true
            self.navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    private func configureLayout() {
        view.addSubview(currentLabel)
        view.addSubview(selectDeleteButton)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(18)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        currentLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        selectDeleteButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
        
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WishListTypingTableViewCell.self, forCellReuseIdentifier: WishListTypingTableViewCell.cellId)
        tableView.register(WishListDoneTableViewCell.self, forCellReuseIdentifier: WishListDoneTableViewCell.cellId)
        //tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }

}


extension EditWishListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        wishList.count + 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if deleteMode {
            if deleteWishList.contains(wishList[indexPath.row].wishId) {
                if let index = deleteWishList.firstIndex(where: { $0 == wishList[indexPath.row].wishId }) {
                    deleteWishList.remove(at: index)
                }
            } else {
                deleteWishList.append(wishList[indexPath.row].wishId)
            }
            
            tableView.reloadData()
        } else {
            if indexPath.row < wishList.count {
                isEditIndex = indexPath.row
                self.tableView.reloadData()
            } else {
                isEditIndex = -1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < wishList.count {
            
            if indexPath.row == isEditIndex {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListTypingTableViewCell.cellId, for: indexPath) as? WishListTypingTableViewCell else { return UITableViewCell() }
                
                cell.wishListTextField.text = wishList[indexPath.row].wishText
                cell.wishListTextField.delegate = self
                cell.selectionStyle = .none
                
                return cell
            } else {
                let item = wishList[indexPath.row]
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListDoneTableViewCell.cellId, for: indexPath) as? WishListDoneTableViewCell else { return UITableViewCell() }
                
                if deleteWishList.contains(item.wishId) {
                    cell.selectAction()
                } else {
                    cell.deselectAction()
                }
                
                cell.setText(item: item)
                cell.selectionStyle = .none
                
                return cell
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListTypingTableViewCell.cellId, for: indexPath) as? WishListTypingTableViewCell else { return UITableViewCell() }
            
            cell.wishListTextField.delegate = self
            cell.wishListTextField.text = ""
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    
}


extension EditWishListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if isEditIndex != -1 {
            
            var replace = wishList[isEditIndex]
            replace.wishText = textField.text ?? ""
            delegate?.editData(item: replace)
            isEditIndex = -1
        } else {
            delegate?.addData(text: textField.text ?? "")
        }
        
        return true
    }
}
