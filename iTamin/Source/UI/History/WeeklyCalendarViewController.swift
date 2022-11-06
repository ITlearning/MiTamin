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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        configureLayout()
    }
    
    func configureLayout() {
        let calendar = UIHostingController(rootView: calendarView)
        view.addSubview(calendar.view)
        view.addSubview(stackView)
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
        
        mytamin.view.snp.makeConstraints {
            $0.top.equalTo(calendar.view.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
    }

}

extension WeeklyCalendarViewController: CalendarDelegate {
    func calendarTap(date: String) {
        let replace = date.components(separatedBy: ".")
        self.viewModel.selectWeeklyDate = replace.last ?? ""
        //viewModel.getCalendarWeekly(date: date)
        print(date)
    }
}
