//
//  DoneWishListViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit

class DoneWishListViewController: UIViewController {

    private let tableView = UITableView()
    
    let viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    var selectAction: ((WishListModel) -> ())?
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.backgroundColor = UIColor.grayColor7
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        return button
    }()
    
    init(selectWishList: WishListModel?) {
        viewModel.selectWishList = selectWishList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.getWishList()
        navigationConfigure(title: "완료한 위시리스트")
        bindCombine()
        configureLayout()
        configureTableView()
    }
    
    func activeButton() {
        doneButton.backgroundColor = UIColor.primaryColor
        doneButton.isEnabled = true
    }
    
    func disActiveButton() {
        doneButton.backgroundColor = UIColor.grayColor7
        doneButton.isEnabled = false
    }
    
    func bindCombine() {
        viewModel.$wishList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.tableView.reloadData()
            })
            .cancel(with: cancelBag)
        
        viewModel.$selectWishList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                if value == nil {
                    self.disActiveButton()
                } else {
                    self.activeButton()
                }
                self.tableView.reloadData()
            })
            .cancel(with: cancelBag)
        
        doneButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.selectAction?(self.viewModel.selectWishList ?? WishListModel(wishId: 0, wishText: "", count: 0))
                self.navigationController?.popViewController(animated: true)
            })
            .cancel(with: cancelBag)
    }

    
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WishListTypingTableViewCell.self, forCellReuseIdentifier: WishListTypingTableViewCell.cellId)
        tableView.register(WishListDoneTableViewCell.self, forCellReuseIdentifier: WishListDoneTableViewCell.cellId)
        tableView.separatorStyle = .none
    }
    
    
    private func configureLayout() {
        view.addSubview(tableView)
        view.addSubview(doneButton)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(19)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(19)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(56)
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
        
    }
}

extension DoneWishListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.wishList.count
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
        if viewModel.selectWishList?.wishId == viewModel.wishList[indexPath.row].wishId {
            viewModel.selectWishList = nil
            
        } else {
            viewModel.selectWishList = viewModel.wishList[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.wishList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListDoneTableViewCell.cellId, for: indexPath) as? WishListDoneTableViewCell else { return UITableViewCell() }
        
        cell.setText(item: item)
        cell.selectionStyle = .none
        
        if viewModel.selectWishList?.wishId == viewModel.wishList[indexPath.row].wishId {
            cell.selectAction()
        } else {
            cell.deselectAction()
        }
        
        return cell
    }
    
    
}
