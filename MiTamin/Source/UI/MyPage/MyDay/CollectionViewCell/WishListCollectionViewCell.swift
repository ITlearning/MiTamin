//
//  WishListCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/24.
//

import UIKit
import SnapKit

protocol WishListCollectionViewDelegate: AnyObject {
    func addData(text: String)
    func editData(item: WishListModel)
    func deleteData(idx: Int)
    func selectIndex(text: String, idx: Int)
}

class WishListCollectionViewCell: UICollectionViewCell {
    static let cellId = "WishListCollectionViewCell"
    
    var wishList: [WishListModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var editMode: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var currentWishList: [WishListModel] = []
    
    var deleteIndex: Int = 0
    var deleteWishList: [Int] = []
    var deleteWishListToServer: [Int] = []
    
    var selectIndex: Int = 0
    var isOpen: Bool = false
    var cancelBag = CancelBag()
    
    weak var delegate: WishListCollectionViewDelegate?
    var deleteOn: Bool = false
    
    private let deletePopupView: UIView = {
        let customView = UIView()
        customView.layer.cornerRadius = 8
        //customView.backgroundColor = .backgroundColor2
        customView.backgroundColor = .white
        customView.layer.applyShadow(color: UIColor.black, alpha: 0.1, x: 0, y: 4, blur: 20)
        customView.alpha = 0.0
        return customView
    }()
    
    private let deleteCancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("실행취소", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        
        return button
    }()

    private let deletePopupInfoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "InfoIcon")
        
        return imageView
    }()
    
    private let deletePopupTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "리스트가 삭제되었어요"
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicRegular(size: 16)
        
        return label
    }()
    
    private let tableView = UITableView()
    
    private let wishListMainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "자신을 위해서 해보고\n싶은 행동이 있나요?"
        label.textAlignment = .left
        label.font = UIFont.SDGothicBold(size: 24)
        label.numberOfLines = 0
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureTableView()
        bindCombine()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 100, right: 0)
            
            if deleteIndex == -1 {
                tableView.scrollToRow(at: IndexPath(row: wishList.count, section: 0), at: .bottom, animated: true)
            } else {
                tableView.scrollToRow(at: IndexPath(row: deleteIndex, section: 0), at: .bottom, animated: true)
            }
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    func setText(text: String) {
        wishListMainTitleLabel.text = text
    }
    
    func bindCombine() {
        deleteCancelButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.deleteOn = false
                self.wishList = self.currentWishList
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.deletePopupView.alpha = 0.0
                }, completion: nil)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            .cancel(with: cancelBag)
    }
    
    func deleteAction() {
        deleteOn = true
        
        deleteProgressOnDevice()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.deletePopupView.alpha = 1.0
        }, completion: { _ in
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.deletePopupView.alpha = 0.0
            }, completion: nil)
            
            if self.deleteOn {
                self.deleteProgressOnServer()
            }
        })
        
    }
    
    func deleteProgressOnDevice() {
        
        currentWishList = wishList
        deleteWishListToServer = deleteWishList
        
        deleteWishList.forEach { idx in
            if let index = wishList.firstIndex(where: { $0.wishId == idx }) {
                wishList.remove(at: index)
            }
        }
        
        deleteWishList.removeAll()
        tableView.reloadData()
    }
    
    func deleteProgressOnServer() {
        
        deleteWishListToServer.forEach { idx in
            delegate?.deleteData(idx: idx)
        }
        
        deleteWishListToServer.removeAll()
    }
    
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        tableView.register(WishListTypingTableViewCell.self, forCellReuseIdentifier: WishListTypingTableViewCell.cellId)
        tableView.register(WishListDoneTableViewCell.self, forCellReuseIdentifier: WishListDoneTableViewCell.cellId)
        //tableView.allowsSelection = false
        tableView.separatorStyle = .none
        //tableView.keyboardDismissMode = .onDrag
    }
    
    private func configureLayout() {
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.addSubview(wishListMainTitleLabel)
        self.addSubview(tableView)
        self.addSubview(deletePopupView)
        
        deletePopupView.addSubview(deletePopupInfoIcon)
        deletePopupView.addSubview(deleteCancelButton)
        deletePopupView.addSubview(deletePopupTitleLabel)
        
        tableView.tableHeaderView = headerView
        tableView.showsVerticalScrollIndicator = false
        
        headerView.snp.makeConstraints {
            $0.width.equalTo(tableView.snp.width)
            $0.height.equalTo(126)
        }
        
        wishListMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.top).offset(40)
            $0.leading.equalTo(headerView.snp.leading).offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(18)
            $0.trailing.equalTo(self.snp.trailing).inset(18)
            $0.bottom.equalTo(self.snp.bottom).inset(20)
        }
        
        deletePopupView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom).inset(76)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
        
        deleteCancelButton.snp.makeConstraints {
            $0.top.equalTo(deletePopupView.snp.top).offset(8)
            $0.trailing.equalTo(deletePopupView.snp.trailing).inset(16)
            $0.height.equalTo(40)
            $0.width.equalTo(108)
        }
        
        deletePopupInfoIcon.snp.makeConstraints {
            $0.top.equalTo(deletePopupView.snp.top).offset(16)
            $0.leading.equalTo(deletePopupView.snp.leading).offset(16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        deletePopupTitleLabel.snp.makeConstraints {
            $0.top.equalTo(deletePopupView.snp.top).offset(20)
            $0.leading.equalTo(deletePopupInfoIcon.snp.trailing).offset(16)
        }
    }
    
    @objc
    func cancelAction() {
        deleteWishList = []
        deleteIndex = -1
        self.endEditing(true)
        editMode = false
    }
}

extension WishListCollectionViewCell: WishListDelegate {
    func textFieldDone(text: String) {
        delegate?.addData(text: text)
    }
    func textFieldEdit(item: WishListModel) {
        deleteIndex = -1
        deleteWishList = []
        delegate?.editData(item: item)
        
        editMode = false
    }
}

extension WishListCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
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
        if indexPath.row < wishList.count {
            currentWishList = wishList
            deleteWishList = [wishList[indexPath.row].wishId]
            deleteIndex = indexPath.row
            print(deleteWishList)
            self.delegate?.selectIndex(text: wishList[indexPath.row].wishText, idx: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < wishList.count {
            
            if (deleteIndex == indexPath.row) && editMode {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListTypingTableViewCell.cellId, for: indexPath) as? WishListTypingTableViewCell else { return UITableViewCell() }
                cell.editModel = true
                cell.setMode()
                cell.wishListTextField.text = wishList[deleteIndex].wishText
                cell.wishListTextField.delegate = self
                
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                        
                let doneButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction))
                        
                toolbar.setItems([doneButton], animated: false)
                        
                //toolbar를 넣고싶은 textField 및 textView 필자의 경우 recommendDataTextView
                cell.wishListTextField.inputAccessoryView = toolbar
                
                cell.wishListTextField.becomeFirstResponder()
                cell.selectionStyle = .none
                
                return cell
            } else {
                let item = wishList[indexPath.row]
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListDoneTableViewCell.cellId, for: indexPath) as? WishListDoneTableViewCell else { return UITableViewCell() }
                
                cell.setText(item: item)
                cell.selectionStyle = .none
                
                return cell
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListTypingTableViewCell.cellId, for: indexPath) as? WishListTypingTableViewCell else { return UITableViewCell() }
            
            cell.editModel = false
            cell.setMode()
            cell.wishListTextField.text = ""
            
            cell.delegate = self
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction))
                    
            toolbar.setItems([doneButton], animated: false)
                    
            //toolbar를 넣고싶은 textField 및 textView 필자의 경우 recommendDataTextView
            cell.wishListTextField.inputAccessoryView = toolbar
            
            cell.selectionStyle = .none
            return cell
            
        }
        
        
    }
    
    
}


extension WishListCollectionViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var data = wishList[deleteIndex]
        data.wishText = textField.text ?? ""
        
        wishList[deleteIndex] = data
        
        delegate?.editData(item: data)
        deleteIndex = -1
        deleteWishList = []
        
        editMode = false
        textField.resignFirstResponder()
        return true
    }
}
