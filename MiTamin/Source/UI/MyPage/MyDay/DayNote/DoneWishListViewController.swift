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
    
    private let loadingText: UILabel = {
        let label = UILabel()
        label.text = "작고 소중한 서버에서\n열심히 불러오는 중..."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicRegular(size: 15)
        label.alpha = 0.0
        return label
    }()
    
    init(selectWishList: WishListModel?) {
        viewModel.selectWishList = selectWishList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationConfigure(title: "완료한 위시리스트")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        showLoadingText()
        viewModel.getWishList()
        bindCombine()
        configureLayout()
        configureTableView()
    }
    
    func showLoadingText() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.loadingText.alpha = 1.0
        })
    }
    
    func hideLoadText() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.loadingText.alpha = 0.0
        })
    }
    
    func showTableView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.tableView.alpha = 1.0
        }, completion: { _ in
            self.tableView.reloadData()
        })
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
                if !value.isEmpty {
                    self.hideLoadText()
                    self.showTableView()
                }
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
        
        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                if value {
                    self.loadingText.text = "작고 소중한 서버에서\n열심히 불러오는 중..."
                } else {
                    if self.viewModel.wishList.count == 0 {
                        UIView.animate(withDuration: 0.4, animations: {
                            self.loadingText.text = "작성한 위시리스트가 없어요,,🥺"
                        })
                    }
                }
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
        view.addSubview(loadingText)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(19)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(19)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(56)
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
        
        loadingText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
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
