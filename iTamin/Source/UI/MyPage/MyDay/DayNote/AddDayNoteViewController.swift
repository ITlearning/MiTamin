//
//  AddDayNoteViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import UIKit
import SnapKit
import SkeletonView

class AddDayNoteViewController: UIViewController {

    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    var scrollView = UIScrollView()
    var datePickerView = CustomDatePickerView()
    var blackDemmedView = UIView()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicBold(size: 18)
        label.text = "fdsdfsdfds"
        label.isSkeletonable = true
        return label
    }()
    
    private let arrowDownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "downArrow")
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, arrowDownImage])
        stackView.spacing = 8
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openPopup))
        stackView.addGestureRecognizer(tapGesture)
        stackView.isSkeletonable = true
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stackView.startSkeletonAnimation()
        navigationConfigure(title: "기록남기기")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.loadDays()
        startSkeleton()
        bindCombine()
        configureLayout()
    }
    
    func startSkeleton() {
        dateLabel.startSkeletonAnimation()
        dateLabel.showGradientSkeleton()
        arrowDownImage.startSkeletonAnimation()
        arrowDownImage.showGradientSkeleton()
    }
    
    func stopSkeleton() {
        dateLabel.stopSkeletonAnimation()
        dateLabel.hideSkeleton()
        arrowDownImage.stopSkeletonAnimation()
        arrowDownImage.hideSkeleton()
    }
    
    func bindCombine() {
        viewModel.$days
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                self.datePickerView.days = value
            })
            .cancel(with: cancelBag)
        
        viewModel.$currentDay
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                
                if value != "" {
                    self.stackView.stopSkeletonAnimation()
                    self.stopSkeleton()
                }
                
                self.dateLabel.text = value
                
            })
            .cancel(with: cancelBag)
    }
    
    @objc
    func openPopup() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.datePickerView.snp.remakeConstraints {
                $0.bottom.equalTo(self.view.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(316)
            }
            self.datePickerView.alpha = 1.0
            self.blackDemmedView.alpha = 0.7
            self.datePickerView.superview?.layoutSubviews()
        })
    }
    
    @objc
    func dismissAction() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.datePickerView.snp.remakeConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(316)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(316)
            }
            self.datePickerView.alpha = 0.0
            self.blackDemmedView.alpha = 0.0
            self.datePickerView.superview?.layoutSubviews()
        })
    }
    
    func configureLayout() {
        blackDemmedView.backgroundColor = .black
        blackDemmedView.alpha = 0.0
        let tapGesutre = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        blackDemmedView.addGestureRecognizer(tapGesutre)
        view.addSubview(scrollView)
        datePickerView.alpha = 0.0
        scrollView.addSubview(stackView)
        view.addSubview(blackDemmedView)
        view.addSubview(datePickerView)
        
        blackDemmedView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        dateLabel.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.height.equalTo(20)
        }
        
        arrowDownImage.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(24)
            $0.leading.equalTo(scrollView.snp.leading).offset(20)
        }
        
        datePickerView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(316)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(316)
        }
    }
}
