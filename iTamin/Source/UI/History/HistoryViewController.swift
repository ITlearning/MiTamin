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

    private let mainMiTaminLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mitamin")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bellButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Bell"), for: .normal)
        
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
    
    private let graphView: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        
        return v
    }()
    
    private let calendarView: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        
        return v
    }()
    
    private let mindCalLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 달 가장 많이 느낀 감정"
        label.textColor = UIColor.black
        label.font = UIFont.SDGothicMedium(size: 16)
        
        return label
    }()
    
    private lazy var feelingRankView = FeelingRankView()
    
    private let collectMyTaminLabel: UILabel = {
        let label = UILabel()
        label.text = "마이타민 모아보기"
        label.textColor = UIColor.black
        label.font = UIFont.SDGothicBold(size: 18)
        
        return label
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(title: "히스토리", image: UIImage(named: "icon-card-mono"), selectedImage: UIImage(named: "icon-card-mono"))
        configureLayout()
        
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
        scrollView.addSubview(graphView)
        scrollView.addSubview(mindCalLabel)
        let vc = UIHostingController(rootView: feelingRankView)
        scrollView.addSubview(vc.view)
        scrollView.addSubview(collectMyTaminLabel)
        
        scrollView.addSubview(calendarView)
        
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
        
        graphView.snp.makeConstraints {
            $0.top.equalTo(weekMindConditionTitle.snp.bottom).offset(16)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).inset(20)
            $0.height.equalTo(140)
        }
        
        mindCalLabel.snp.makeConstraints {
            $0.top.equalTo(graphView.snp.bottom).offset(40)
            $0.leading.equalTo(graphView.snp.leading)
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
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(collectMyTaminLabel.snp.bottom).offset(24)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).inset(20)
            $0.height.equalTo(400)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
    }

}
