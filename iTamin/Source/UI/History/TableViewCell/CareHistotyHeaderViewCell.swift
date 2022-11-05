//
//  CareHistotyHeaderViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/11/05.
//

import UIKit
import SnapKit

class CareHistoryHeaderViewCell: UITableViewHeaderFooterView {

    static let cellId = "careHistoryHeaderViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.SDGothicBold(size: 18)
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(text: String) {
        self.label.text = text
    }
    
    private func configureCellLayout() {
        self.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(10)
            $0.leading.equalTo(self.snp.leading).offset(20)
        }
    }
    

}
