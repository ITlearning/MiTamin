//
//  CareHistoryViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import SwiftUI

class CareHistoryViewController: UIViewController {

    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    lazy var categoryView = CategoryView(viewModel: self.viewModel)
    lazy var categoryBottomSheetView = UIHostingController(rootView: CategoryBottomSheetView(type: .history, index: viewModel.selectIndex))
    lazy var hostingView = UIHostingController(rootView: categoryView)
    
    private let tableView = UITableView()
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(sortAction))
        
        return button
    }()
    
    @objc
    func sortAction() {
        presentModal()
    }
    
    private let demmedView = DemmedView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationConfigure(title: "칭찬 처방 기록")
        navigationItem.rightBarButtonItem = filterButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.getCategoryCareData()
        configureLayout()
        configureTableView()
        bindCombine()
    }
    
    private func bindCombine() {
        viewModel.$careList
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                self?.tableView.reloadData()
            })
            .cancel(with: cancelBag)
        
        viewModel.$selectIndex
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.setCategoryView(isOpen: value.count != 0)
                self.viewModel.getCategoryCareData(category: value)
            })
            .cancel(with: cancelBag)
        
        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                if value {
                    self.demmedView.showDemmedPopup(text: "처방 기록을 불러오고 있어요..!")
                } else {
                    self.demmedView.hide()
                }
            })
            .cancel(with: cancelBag)
    }
    
    private func setCategoryView(isOpen: Bool) {
        if isOpen {
            UIView.animate(withDuration: 0.3, animations: {
                self.hostingView.view.snp.remakeConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                    $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
                    $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
                    $0.height.equalTo(30)
                }
                
                self.hostingView.view.superview?.layoutSubviews()
            })
        } else {
            UIView.animate(withDuration: 0.3,  animations: {
                self.hostingView.view.snp.remakeConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
                    $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
                    $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
                    $0.height.equalTo(0)
                }
                self.hostingView.view.superview?.layoutSubviews()
            })
        }

    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        
        view.addSubview(hostingView.view)
        
        hostingView.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(hostingView.view.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CareHistoryTableViewCell.self, forCellReuseIdentifier: CareHistoryTableViewCell.cellId)
        tableView.register(CareHistoryHeaderViewCell.self, forHeaderFooterViewReuseIdentifier: CareHistoryHeaderViewCell.cellId)
        tableView.separatorStyle = .none
    }
    
    func presentModal() {
        let categoryBottomSheetView = UIHostingController(rootView: CategoryBottomSheetView(type: .history, index: viewModel.selectIndex))
        let nav = UINavigationController(rootViewController: categoryBottomSheetView)
        nav.navigationController?.isNavigationBarHidden = true
        nav.modalPresentationStyle = .pageSheet
        nav.isNavigationBarHidden = true
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        categoryBottomSheetView.rootView.buttonTouch = { [weak self] text, idx in
            guard let self = self else { return }
            if !self.viewModel.selectIndex.contains(idx) {
                self.viewModel.selectIndex.append(idx)
            } else {
                if let index = self.viewModel.selectIndex.firstIndex(where: { $0 == idx}) {
                    self.viewModel.selectIndex.remove(at: index)
                }
            }
        }
        
        categoryBottomSheetView.rootView.doneAction = { array in
            self.viewModel.selectIndex = array
            nav.dismiss(animated: true)
        }
        
        present(nav, animated: true)
    }

}


extension CareHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CareHistoryHeaderViewCell.cellId) as? CareHistoryHeaderViewCell else { return UIView() }
        header.setTitle(text: viewModel.careList[section].date)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.careList[section].data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.careList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CareHistoryTableViewCell.cellId, for: indexPath) as? CareHistoryTableViewCell else { return UITableViewCell() }
        let item = viewModel.careList[indexPath.section].data[indexPath.row]
        cell.setText(title: "\(item.careMsg1)\n\(item.careMsg2)", date: item.takeAt)
        
        return cell
    }
    
}
