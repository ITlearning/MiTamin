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
    
    lazy var categoryView = CategoryView()
    
    private let tableView = UITableView()
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(sortAction))
        
        return button
    }()
    
    @objc
    func sortAction() {
        
    }
    
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
    }
    
    private func bindCombine() {
        viewModel.$careList
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                self?.tableView.reloadData()
            })
            .cancel(with: cancelBag)
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        let hostingView = UIHostingController(rootView: categoryView)
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
    }

}


extension CareHistoryViewController: UITableViewDelegate, UITableViewDataSource {
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
