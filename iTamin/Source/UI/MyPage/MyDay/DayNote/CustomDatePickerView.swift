//
//  CustomDatePickerView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CustomDatePickerView: UIView {

    var days: [[String]] = [[]] {
        didSet {
            datePicker.reloadAllComponents()
        }
    }
    
    var selectDay: String = ""
    var cancelBag = CancelBag()
    var selectDayPrint: String = "" {
        didSet {
            datePicker.reloadAllComponents()
        }
    }
    var selectYear: Int = 0
    var selectMonth: Int = 0
    var buttonSelect: ((String,String, Int, Int) -> ())?
    
    lazy var datePicker: UIPickerView = {
        let datePicker = UIPickerView()
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.backgroundColor = .white
        return datePicker
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureLayout()
        bindCombine()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func bindCombine() {
        selectButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                
                let selectPrintDayString = "\(self?.selectYear ?? 0)년 \(self?.selectMonth ?? 0)월의 마이데이"
                let selectDayString = "\(self?.selectYear ?? 0).\(self?.selectMonth ?? 0)"
                
                self?.buttonSelect?(selectPrintDayString, selectDayString, self?.selectYear ?? 0, self?.selectMonth ?? 0)
            })
            .cancel(with: cancelBag)
    }
    
    func configureLayout() {
        self.addSubview(datePicker)
        self.addSubview(selectButton)
        
        selectButton.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom).inset(30)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
        
        datePicker.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom).inset(66)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.top.equalTo(self.snp.top).offset(20)
        }
    }
    
}

extension CustomDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        days[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return days[component][row]+"년"
        } else {
            return days[component][row]+"월"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            self.selectYear = Int(days[component][row]) ?? 0
        } else {
            self.selectMonth = Int(days[component][row]) ?? 0

        }
        
        print(self.selectYear, self.selectMonth)
    }
    
    
}
