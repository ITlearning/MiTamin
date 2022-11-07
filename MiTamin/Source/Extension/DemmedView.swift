//
//  DemmedView.swift
//  MiTamin
//
//  Created by Tabber on 2022/11/07.
//

import UIKit
import SnapKit
import Combine


class DemmedView: UIView {

    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.SDGothicBold(size: 15)
        label.text = "로그인 시도중이에요!"
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
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.addSubview(label)
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func showDemmedPopup(text:String) {
        label.text = text
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(self)
            
            self.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.width)
                $0.height.equalTo(UIScreen.main.bounds.height)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

}
