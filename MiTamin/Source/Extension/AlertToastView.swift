//
//  AlertToastView.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import UIKit
import SnapKit

class AlertToastView: UIView {

    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicBold(size: 15)
        label.text = "dsadsadasjhjk"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let spacingView = UIView()
    
    let view = UIView()
    
    lazy var stackView: UIStackView = {
    
        let stackView = UIStackView(arrangedSubviews: [spacingView, label, spacingView])
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        
        self.backgroundColor = .backgroundColor2
        self.layer.cornerRadius = 8
        view.alpha = 0.0
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        spacingView.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        self.addSubview(view)
    }
    
    func showToastPopup(text:String) {
        label.text = text
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(self)
            
            self.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(100)
                $0.height.equalTo(60)
                $0.leading.equalToSuperview().offset(40)
                $0.trailing.equalToSuperview().inset(40)
            }
            
            self.label.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
            self.view.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.view.alpha = 1.0
                self.alpha = 1.0
            }, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.hide()
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
            self.alpha = 0.0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

}
