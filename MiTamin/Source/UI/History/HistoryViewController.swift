//
//  HistoryViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/09/16.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit
import SwiftUI


class HistoryViewController: UIViewController {

    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    
    private let mainMiTaminLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mitamin")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bellButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Bell"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let scrollView = UIScrollView()
    
    private let complimentHistoryTitle: UILabel = {
        let label = UILabel()
        label.text = "칭찬 처방 기록"
        label.textColor = UIColor.black
        label.font = UIFont.SDGothicBold(size: 18)
        
        return label
    }()
    
    private let complimentHistoryView: UIView = {
        let customView = UIView()
        customView.layer.cornerRadius = 12
        //customView.backgroundColor = .backgroundColor2
        customView.backgroundColor = .white
        customView.layer.applyShadow(color: UIColor.black, alpha: 0.1, x: 0, y: 8, blur: 20)
        return customView
    }()
    
    private let complimentHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 계획했던 일을 전부 했어.\n 성실하게 노력하는 내 모습이 좋아."
        label.textColor = UIColor.black
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textAlignment = .left
        label.isSkeletonable = true
        label.numberOfLines = 0
        return label
    }()
    
    private let complimentResetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-refresh-mono"), for: .normal)
        
        return button
    }()
    
    private let complimentDayLabel: UILabel = {
        let label = UILabel()
        label.text = "22.09.01"
        label.textColor = UIColor.grayColor2
        label.font = UIFont.SDGothicRegular(size: 12)
        label.isSkeletonable = true
        return label
    }()
    
    private let allcomplimentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 8
        button.setTitle("전체 처방 기록 보기", for: .normal)
        button.setTitleColor( UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        
        return button
    }()
    
    private let mindReportHistoryTitle: UILabel = {
        let label = UILabel()
        label.text = "감정 진단 기록"
        label.textColor = UIColor.black
        label.font = UIFont.SDGothicBold(size: 18)
        
        return label
    }()
    
    private let weekMindConditionTitle: UILabel = {
        let label = UILabel()
        label.text = "주간 마음 컨디션"
        label.textColor = UIColor.black
        label.font = UIFont.SDGothicMedium(size: 16)
        
        return label
    }()
    
    private let mindCalLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 달 가장 많이 느낀 감정"
        label.textColor = UIColor.black
        label.font = UIFont.SDGothicMedium(size: 16)
        
        return label
    }()
    
    private let pastButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-arrow-left-circle-mono"), for: .normal)
        
        return button
    }()
    
    private let calendarMonthLabel: UILabel = {
        let label = UILabel()
        label.text = Date.dateToStringKor(date: Date())
        label.textColor = UIColor.black
        label.font = UIFont.SDGothicMedium(size: 16)
        return label
    }()
    
    private let futureButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-arrow-right-circle-mono"), for: .normal)
        
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pastButton, calendarMonthLabel, futureButton])
        stackView.axis = .horizontal
        stackView.spacing = 24
        
        return stackView
    }()
    
    private lazy var feelingRankView = FeelingRankView(viewModel: self.viewModel)
    private lazy var calendarView = CalendarView(viewModel: self.viewModel)
    private lazy var conditionGraphView = ConditionChartView(viewModel: self.viewModel)
    
    private let collectMyTaminLabel: UILabel = {
        let label = UILabel()
        label.text = "마이타민 모아보기"
        label.textColor = UIColor.black
        label.font = UIFont.SDGothicBold(size: 18)
        
        return label
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFeelingRank()
        viewModel.getWeeklyMental()
        if UserDefaults.standard.bool(forKey: "updateCalendarData") {
            viewModel.getCalendarMonthly(date: Date.dateToString(date: viewModel.currentDate))
            UserDefaults.standard.set(true, forKey: "updateCalendar")
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(title: "히스토리", image: UIImage(named: "icon-card-mono"), selectedImage: UIImage(named: "icon-card-mono"))
        configureLayout()
        viewModel.getCareRandomData()
        viewModel.getFeelingRank()
        viewModel.getWeeklyMental()
        bindCombine()
    }
    
    private func bindCombine() {
        viewModel.$randomCareData
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.setRandomText(item: value)
            })
            .cancel(with: cancelBag)
        
        complimentResetButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.complimentHistoryLabel.startSkeletonAnimation()
                self.complimentHistoryLabel.showGradientSkeleton()
                self.complimentDayLabel.startSkeletonAnimation()
                self.complimentDayLabel.showGradientSkeleton()
                self.viewModel.getCareRandomData()
            })
            .cancel(with: cancelBag)
        
        allcomplimentButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in
                let vc =  CareHistoryViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .cancel(with: cancelBag)
        
        pastButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let date = self.viewModel.currentDate
                
                self.viewModel.currentDate = Calendar.current.date(byAdding: .month, value: -1, to: date) ?? Date()
                self.setCalendarText(date: self.viewModel.currentDate)

            })
            .cancel(with: cancelBag)
        
        futureButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let date = self.viewModel.currentDate
                self.viewModel.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: date) ?? Date()
                self.setCalendarText(date: self.viewModel.currentDate)
            })
            .cancel(with: cancelBag)
        
        viewModel.$currentDate
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.viewModel.getCalendarMonthly(date: Date.dateToString(date: value))
            })
            .cancel(with: cancelBag)
    }
    
    func setCalendarText(date: Date) {
        calendarMonthLabel.text = Date.dateToStringKor(date: date)
    }
    
    func setRandomText(item: RandomCareModel?) {
        
        self.complimentHistoryLabel.stopSkeletonAnimation()
        self.complimentHistoryLabel.hideSkeleton()
        self.complimentDayLabel.stopSkeletonAnimation()
        self.complimentDayLabel.hideSkeleton()
        
        complimentHistoryLabel.text = "\(item?.careMsg1 ?? "작성한 처방이 없어요!")\n\(item?.careMsg2 ?? "지금 칭찬 처방을 작성해보세요!")"
        complimentDayLabel.text = item?.takeAt ?? ""
        
        
    }
    
    private func configureLayout() {
        view.addSubview(mainMiTaminLogoImageView)
        view.addSubview(bellButton)
        view.addSubview(scrollView)
        scrollView.addSubview(complimentHistoryTitle)
        scrollView.addSubview(complimentHistoryView)
        complimentHistoryView.addSubview(complimentHistoryLabel)
        complimentHistoryView.addSubview(complimentResetButton)
        complimentHistoryView.addSubview(complimentDayLabel)
        complimentHistoryView.addSubview(allcomplimentButton)
        scrollView.addSubview(mindReportHistoryTitle)
        scrollView.addSubview(weekMindConditionTitle)
        
        
        let graphView = UIHostingController(rootView: conditionGraphView)
        
        
        scrollView.addSubview(graphView.view)
        scrollView.addSubview(mindCalLabel)
        let vc = UIHostingController(rootView: feelingRankView)
        scrollView.addSubview(vc.view)
        scrollView.addSubview(collectMyTaminLabel)
        scrollView.addSubview(stackView)
        let calendarView = UIHostingController(rootView: calendarView)
        scrollView.addSubview(calendarView.view)
        calendarView.rootView.delegate = self
        
        
        mainMiTaminLogoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.width.equalTo(73)
            $0.height.equalTo(16)
        }
        
        bellButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(mainMiTaminLogoImageView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        complimentHistoryTitle.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(24)
            $0.leading.equalTo(scrollView.snp.leading).offset(20)
        }
        
        complimentHistoryView.snp.makeConstraints {
            $0.top.equalTo(complimentHistoryTitle.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
            $0.height.equalTo(172)
        }
        
        complimentHistoryLabel.snp.makeConstraints {
            $0.top.equalTo(complimentHistoryView.snp.top).offset(24)
            $0.leading.equalTo(complimentHistoryView.snp.leading).offset(16)
        }
        
        complimentResetButton.snp.makeConstraints {
            $0.top.equalTo(complimentHistoryLabel.snp.top)
            $0.trailing.equalTo(complimentHistoryView.snp.trailing).inset(16)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        complimentDayLabel.snp.makeConstraints {
            $0.top.equalTo(complimentHistoryLabel.snp.bottom).offset(16)
            $0.leading.equalTo(complimentHistoryView.snp.leading).offset(16)
        }
        
        allcomplimentButton.snp.makeConstraints {
            $0.bottom.equalTo(complimentHistoryView.snp.bottom).inset(16)
            $0.leading.equalTo(complimentHistoryView.snp.leading).offset(20)
            $0.trailing.equalTo(complimentHistoryView.snp.trailing).inset(19)
            $0.height.equalTo(40)
        }
        
        mindReportHistoryTitle.snp.makeConstraints {
            $0.top.equalTo(complimentHistoryView.snp.bottom).offset(48)
            $0.leading.equalTo(complimentHistoryView.snp.leading)
        }
        
        weekMindConditionTitle.snp.makeConstraints {
            $0.top.equalTo(mindReportHistoryTitle.snp.bottom).offset(24)
            $0.leading.equalTo(mindReportHistoryTitle.snp.leading)
        }
        
        graphView.view.snp.makeConstraints {
            $0.top.equalTo(weekMindConditionTitle.snp.bottom).offset(36)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(140)
        }
        
        mindCalLabel.snp.makeConstraints {
            $0.top.equalTo(graphView.view.snp.bottom).offset(60)
            $0.leading.equalTo(graphView.view.snp.leading).offset(20)
        }
        
        vc.view.snp.makeConstraints {
            $0.top.equalTo(mindCalLabel.snp.bottom).offset(16)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
        }
        
        collectMyTaminLabel.snp.makeConstraints {
            $0.top.equalTo(vc.view.snp.bottom).offset(48)
            $0.leading.equalTo(mindCalLabel)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(collectMyTaminLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        pastButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        futureButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        calendarView.view.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(24)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).inset(20)
            $0.height.equalTo(400)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
    }

}

extension HistoryViewController: CalendarDelegate {
    func calendarTap(date: String) {
        let replace = date.components(separatedBy: ".")
        viewModel.selectWeeklyDate = replace.last ?? ""
        viewModel.selectDate = date
        let vc = WeeklyCalendarViewController(viewModel: viewModel, date: date)
        navigationController?.pushViewController(vc, animated: true)
        print(date)
    }
}
