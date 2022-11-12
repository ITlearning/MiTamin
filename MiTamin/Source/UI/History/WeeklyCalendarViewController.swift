//
//  WeeklyCalendarViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/11/06.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit
import SwiftUI

class WeeklyCalendarViewController: UIViewController {
    
    var viewModel: HistoryViewController.ViewModel
    var cancelBag = CancelBag()
    
    private lazy var calendarView = CalendarView(viewModel: self.viewModel, type: .week)
    private lazy var mytaminReportView = MyTaminReportView(viewModel: HomeViewController.ViewModel(), historyViewModel: self.viewModel, type: .history)
    private let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "calendar")
        
        return imageView
    }()
    
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicBold(size: 16)
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [calendarImageView, calendarLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "09.15 Fri"
        label.font = UIFont.SDGothicRegular(size: 12)
        label.textColor = UIColor.grayColor2
        
        return label
    }()
    
    private let mytaminLabel: UILabel = {
        let label = UILabel()
        label.text = "0월0일의 마이타민"
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = .grayColor4
        
        return label
    }()
    
    private lazy var stackViewTwo: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, mytaminLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let sepView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(rgb: 0xF6F4F2)
        
        return v
    }()
    
    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "icon_trashcan"), style: .plain, target: self, action: #selector(deleteAction))
        
        return button
    }()
    
    @objc
    func deleteAction() {
        openPopup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "updateData") {
            viewModel.weeklyCalendarData = nil
            UserDefaults.standard.set(true, forKey: "updateCalendar")
            viewModel.getCalendarWeekly(date: viewModel.selectDate)
            UserDefaults.standard.set(false, forKey: "updateData")
        }
        
        navigationConfigure(title: "진단기록")
    }
   
    init(viewModel: HistoryViewController.ViewModel, date: String) {
        self.viewModel = viewModel
        self.calendarLabel.text = Date.dateToStringKor(date: viewModel.currentDate)
        let replace = date.components(separatedBy: ".")
        self.viewModel.getCalendarWeekly(date: date)
        self.viewModel.selectWeeklyDate = replace.last ?? ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //viewModel.getCalendarMonthly(date: Date.dateToString(date: Date()))
        viewModel.weeklyCalendarData = nil
        self.setCurrentDay(date: viewModel.selectDate)
        setMyTaminText(date: viewModel.selectDate)
        configureLayout()
        bindCombine()
    }
    
    func openPopup() {
        let alertView = UIAlertController(title: "마이타민 삭제", message: "정말로 마이타민을 삭제할까요?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "아니요", style: .cancel) { _ in
            
        }
        let doneButton = UIAlertAction(title: "네", style: .destructive) { _ in
            if let index = self.viewModel.calendarWeekList.firstIndex(where: { Int($0.day) == Int(self.viewModel.selectWeeklyDate) }) {
                self.viewModel.deleteMyTamin(id: self.viewModel.calendarWeekList[index].data?.mytaminId ?? 0)
            }
        }
        
        alertView.addAction(cancelButton)
        alertView.addAction(doneButton)
        
        self.present(alertView, animated: true)
    }
    
    func bindCombine() {
        
        viewModel.buttonClick
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { idx in
                print("버튼 누르면 나오는 데이터",self.viewModel.weeklyCalendarData?.data)
                UserDefaults.standard.set(self.viewModel.weeklyCalendarData?.data?.report?.reportId, forKey: .reportId)
                UserDefaults.standard.set(self.viewModel.weeklyCalendarData?.data?.care?.careId, forKey: .careId)
                let myTaminVC = MyTaminViewController(index: idx)
                myTaminVC.modalPresentationStyle = .fullScreen
                self.present(myTaminVC, animated: true)
            })
            .cancel(with: cancelBag)
        
        viewModel.$weeklyCalendarData
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                if value?.data == nil {
                    self.navigationItem.rightBarButtonItem = nil
                } else {
                    self.navigationItem.rightBarButtonItem = self.deleteButton
                }
            })
            .cancel(with: cancelBag)
        
    }
    
    func configureLayout() {
        let calendar = UIHostingController(rootView: calendarView)
        view.addSubview(calendar.view)
        view.addSubview(stackView)
        view.addSubview(sepView)
        view.addSubview(stackViewTwo)
        let mytamin = UIHostingController(rootView: mytaminReportView)
        view.addSubview(mytamin.view)
        
        calendar.rootView.delegate = self
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(18)
        }
        
        calendar.view.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(15)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(60)
        }
        
        sepView.snp.makeConstraints {
            $0.top.equalTo(calendar.view.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        stackViewTwo.snp.makeConstraints {
            $0.top.equalTo(sepView.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        mytamin.view.snp.makeConstraints {
            $0.top.equalTo(stackViewTwo.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
    }

    private func setCurrentDay(date: String) {
        let date = Date.stringToDate(date: date)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM.dd EEE"
        let result = dateFormatter.string(from: date ?? Date())
        self.dateLabel.text = result
    }
    
    private func setMyTaminText(date: String) {
        let replace = date.components(separatedBy: ".")
        
        if replace.count > 2 {
            mytaminLabel.text = "\(replace[1])월 \(replace[2])일의 마이타민"
        }
    }
    
}

extension WeeklyCalendarViewController: CalendarDelegate {
    func calendarTap(date: String) {
        let replace = date.components(separatedBy: ".")
        self.viewModel.selectWeeklyDate = replace.last ?? ""
        viewModel.selectDate = date
        setCurrentDay(date: date)
        setMyTaminText(date: date)
        if let index = viewModel.calendarWeekList.firstIndex(where: { Int($0.day) == Int(self.viewModel.selectWeeklyDate) }) {
            viewModel.weeklyCalendarData = viewModel.calendarWeekList[index]
        } else {
            viewModel.weeklyCalendarData = nil
            viewModel.getCalendarWeekly(date: date)
        }
        
        print(date)
    }
}
