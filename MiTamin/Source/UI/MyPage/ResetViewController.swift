//
//  ResetViewController.swift
//  MiTamin
//
//  Created by Tabber on 2022/11/07.
//

import UIKit
import SnapKit
import SwiftUI
import Combine
import CombineCocoa

class ResetViewController: UIViewController {

    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    private lazy var resetView = HistoryResetView(viewModel: self.viewModel)
    
    private let demmedView = DemmedView()
    private let toast = AlertToastView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        navigationConfigure(title: "기록 초기화")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.selectIndex = [0,0,0]
        navigationConfigure(title: "기록 초기화")
        configureLayout()
        bindCombine()
    }

    private func bindCombine() {
        
        viewModel.$done
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                if value {
                    self.toast.showToastPopup(text: "초기화 완료!\n새로운 마음으로 시작해보세요 :)")
                }
            })
            .cancel(with: cancelBag)
        
        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                if value {
                    self.demmedView.showDemmedPopup(text: "초기화 중이에요..!")
                } else {
                    self.demmedView.hide()
                }
                
            })
            .cancel(with: cancelBag)
    }
    
    func openPopup() {
        let alert = UIAlertController(title: "초기화", message: "초기화를 선택한 기록은 영구적으로 삭제됩니다.\n정말로 초기화를 진행하시겠어요?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "초기화", style: .destructive) { _ in
            self.viewModel.resetData()
        }
        
        let no = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(no)
        alert.addAction(yes)
        
        self.present(alert, animated: true)
    }
    
    private func configureLayout() {
        let vc = UIHostingController(rootView: resetView)
        vc.rootView.delegate = self
        view.addSubview(vc.view)
        vc.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension ResetViewController: HistoryResetDelegate {
    func touchAction(action: ResetViewTouch) {
        switch action {
        case .mind:
            if viewModel.selectIndex[0] == 0 {
                viewModel.selectIndex[0] = 1
            } else {
                viewModel.selectIndex[0] = 0
            }
        case .care:
            if viewModel.selectIndex[1] == 0 {
                viewModel.selectIndex[1] = 1
            } else {
                viewModel.selectIndex[1] = 0
            }
        case .myDay:
            if viewModel.selectIndex[2] == 0 {
                viewModel.selectIndex[2] = 1
            } else {
                viewModel.selectIndex[2] = 0
            }
        case .resetButton:
            openPopup()
        }
    }
    
}
