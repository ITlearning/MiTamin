//
//  DayNoteDetailViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/11/01.
//

import UIKit
import SwiftUI
import SnapKit
import Combine
import CombineCocoa
import Kingfisher

class DayNoteDetailViewController: UIViewController {

    var dayNoteModel: DayNoteModel
    var isOpen: Bool = false
    var cancelBag = CancelBag()
    var viewModel = ViewModel()
    var alertToastView = AlertToastView()
    
    private lazy var rightMenuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "more-horizontal"), style: .plain, target: self, action: #selector(menuMode))
        button.tintColor = UIColor.grayColor4
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("마이데이 기록 수정하기", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(UIColor.grayColor4, for: .normal)
        button.titleLabel?.font = UIFont.SDGothicRegular(size: 16)
        
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("마이데이 기록 삭제하기", for: .normal)
        button.setTitleColor(UIColor.deleteRed, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.SDGothicRegular(size: 16)
        
        return button
    }()
    
    private let demmedView = UIView()
    
    private let menuView: UIView = {
        let mView = UIView()
        return mView
    }()
    
    init(dayNoteModel: DayNoteModel) {
        self.dayNoteModel = dayNoteModel
        self.viewModel.dayNoteModel = dayNoteModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationConfigure(title: "마이데이 기록")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "MyDayUpdate")
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = rightMenuButton
        configureLayout()
        viewModel.downLoadImage()
        bindCombine()
    }
    
    func alertOn() {
        let alert = UIAlertController(title: "기록 삭제", message: "기록을 정말로 삭제하시겠어요?\n삭제된 내용은 복구할 수 없습니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
            self.viewModel.deleteDayNote()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true)
    }
    
    func openEditView() {
        let addVC = AddDayNoteViewController(dayNoteModel: dayNoteModel, images: viewModel.downloadedImage, isEdit: true)
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    func bindCombine() {
        editButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if self.viewModel.downloadedImage.count == self.dayNoteModel.imgList.count {
                    self.openEditView()
                } else {
                    self.alertToastView.showToastPopup(text: "수정하기 위해서 필요한 데이터를 다운받고 있어요!\n조금만 기다려주세요!")
                }
            })
            .cancel(with: cancelBag)
        
        deleteButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.alertOn()
            })
            .cancel(with: cancelBag)
        
        viewModel.dismissAction.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                UserDefaults.standard.set(true, forKey: "MyDayUpdate")
                self.navigationController?.popViewController(animated: true)
            })
            .cancel(with: cancelBag)
    }
    
    
    
    @objc
    func menuMode() {
        if isOpen {
            UIView.animate(withDuration: 0.3, animations: {
                self.demmedView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.menuView.snp.remakeConstraints {
                    $0.bottom.equalTo(self.view.snp.bottom).offset(154)
                    $0.leading.trailing.equalToSuperview()
                    $0.height.equalTo(154)
                }
                
                self.menuView.superview?.layoutSubviews()
            }, completion: { _ in
                self.demmedView.isHidden = true
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.demmedView.isHidden = false
                self.demmedView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                self.menuView.snp.remakeConstraints {
                    $0.bottom.equalTo(self.view.snp.bottom)
                    $0.leading.trailing.equalToSuperview()
                    $0.height.equalTo(154)
                }
                
                self.menuView.superview?.layoutSubviews()
            })
        }
        
        isOpen.toggle()
    }
    
    func configureLayout() {
        let vc = UIHostingController(rootView: MyDayDetailView(myDayData: dayNoteModel))
        
        view.addSubview(vc.view)
        
        
        demmedView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        demmedView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuMode))
        demmedView.addGestureRecognizer(tapGesture)
        vc.view.addSubview(demmedView)
        vc.view.addSubview(menuView)

        menuView.addSubview(editButton)
        menuView.backgroundColor = .white
        menuView.addSubview(deleteButton)
        
        vc.view.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.view.snp.leading)
            $0.trailing.equalTo(self.view.snp.trailing)
            $0.bottom.equalTo(self.view.snp.bottom)
        }
        
        menuView.snp.makeConstraints {
            $0.bottom.equalTo(self.view.snp.bottom).offset(154)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(154)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(menuView.snp.top)
            $0.leading.equalTo(menuView.snp.leading).offset(20)
            $0.height.equalTo(60)
        }
        
        let separateLine = UIView()
        separateLine.backgroundColor = UIColor(rgb: 0xEDEDED)
        
        menuView.addSubview(separateLine)
        
        separateLine.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom)
            $0.leading.equalTo(editButton.snp.leading)
            $0.trailing.equalTo(self.view.snp.trailing).inset(20)
            $0.height.equalTo(1)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(separateLine.snp.bottom)
            $0.leading.equalTo(separateLine.snp.leading)
            $0.height.equalTo(60)
        }
        
        demmedView.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.snp.bottom)
        }
        
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = 12
        menuView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
}
