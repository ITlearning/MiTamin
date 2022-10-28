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
}

class WishListCollectionViewCell: UICollectionViewCell {
    static let cellId = "WishListCollectionViewCell"
    var wishList: [WishListModel] = [] {
        didSet {
            tableView.reloadData()
            
            if !wishList.isEmpty {
                showTableView()
            } else {
                hideTableView()
            }
        }
    }
    
    weak var delegate: WishListCollectionViewDelegate?
    
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
    
    private let mainillustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Mainillustration")
        
        return imageView
    }()
    
    private let notWriteMainLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 작성된\n위시리스트가 없어요."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    private let notWriteSubLabel: UILabel = {
        let label = UILabel()
        label.text = "위시리스트를 채워주세요!"
        label.numberOfLines = 0
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor3
        
        return label
    }()
    
    
    private let currentLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 리스트"
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = UIColor.grayColor4
        label.isHidden = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func showTableView() {
        tableView.isHidden = false
        currentLabel.isHidden = false
        wishListMainTitleLabel.isHidden = true
        mainillustrationImageView.isHidden = true
        notWriteMainLabel.isHidden = true
        notWriteSubLabel.isHidden = true
    }
    
    func hideTableView() {
        tableView.isHidden = true
        currentLabel.isHidden = true
        wishListMainTitleLabel.isHidden = false
        mainillustrationImageView.isHidden = false
        notWriteMainLabel.isHidden = false
        notWriteSubLabel.isHidden = false
    }
    
    func setText(text: String) {
        wishListMainTitleLabel.text = text
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.register(WishListTypingTableViewCell.self, forCellReuseIdentifier: WishListTypingTableViewCell.cellId)
        tableView.register(WishListDoneTableViewCell.self, forCellReuseIdentifier: WishListDoneTableViewCell.cellId)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    private func configureLayout() {
        self.addSubview(wishListMainTitleLabel)
        self.addSubview(mainillustrationImageView)
        self.addSubview(notWriteMainLabel)
        self.addSubview(notWriteSubLabel)
        self.addSubview(currentLabel)
        self.addSubview(tableView)
        
        wishListMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(40)
            $0.leading.equalTo(self.snp.leading).offset(20)
        }
        
        mainillustrationImageView.snp.makeConstraints {
            $0.top.equalTo(wishListMainTitleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
        
        notWriteMainLabel.snp.makeConstraints {
            $0.top.equalTo(mainillustrationImageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        notWriteSubLabel.snp.makeConstraints {
            $0.top.equalTo(notWriteMainLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        currentLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(40)
            $0.leading.equalTo(self.snp.leading).offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(currentLabel.snp.bottom).offset(14)
            $0.leading.equalTo(self.snp.leading).offset(18)
            $0.trailing.equalTo(self.snp.trailing).inset(18)
            $0.bottom.equalTo(self.snp.bottom).inset(20)
        }
    }
    
}

extension WishListCollectionViewCell: WishListDelegate {
    func textFieldDone(text: String) {
        delegate?.addData(text: text)
    }
    func textFieldEdit(item: WishListModel) {
        delegate?.editData(item: item)
    }
}

extension WishListCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        wishList.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = wishList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListDoneTableViewCell.cellId, for: indexPath) as? WishListDoneTableViewCell else { return UITableViewCell() }
        
        cell.setText(item: item)
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}


