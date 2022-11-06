//
//  MindTextCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/08.
//

import UIKit
import SnapKit
import SwiftUI

class MindTextCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "MindTextCollectionViewCell"
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = CustomViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        return collectionView
    }()
    
    var addAction: (([String]) -> ())?
    var selectCell: (([String]) -> ())?
    
    var cellData: [String] = [] {
        didSet {
            addAction?(cellData)
            collectionView.reloadData()
        }
    }
    
    var selectCellTexts: [String] = [] {
        didSet {
            selectCell?(selectCellTexts)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        
        let mainSubTitleView = UIHostingController(rootView: MainSubTitleView(mainTitle: "3. 하루 진단하기",
                                                                              subTitle: "감정을 진찰해볼까요?"))
        
        addSubview(mainSubTitleView.view)
        addSubview(collectionView)
        
        mainSubTitleView.view.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(mainSubTitleView.view.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.bottom.equalToSuperview()
        }

    }
    
    private func configureCollectionView() {
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayout = CustomViewFlowLayout()
        collectionView.collectionViewLayout = flowLayout
    }
    
    
    func calculateCellWidth(index: Int) -> CGFloat {
        if cellData.count > index {
            let label = UILabel()
            
            label.text = cellData[index]
            label.font = .systemFont(ofSize: 14)
            label.sizeToFit()
            
            return label.frame.width + 45
        } else {
            return 100
        }
    }
}

extension MindTextCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: calculateCellWidth(index: indexPath.row), height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.cellId, for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
        
        let text = cellData[indexPath.row]
        
        cell.setCellText(text: text)
        
        if selectCellTexts.contains(where: { $0 == cellData[indexPath.row] }) {
            cell.selectAction()
        } else {
            cell.deselectAction()
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.cellId, for: indexPath) as? TagCollectionViewCell else { return }
        
        print()
        
        if selectCellTexts.count < 3 {
            if selectCellTexts.contains(where: { $0 == cellData[indexPath.row]}) {
                if let index = selectCellTexts.firstIndex(of: cellData[indexPath.row]) {
                    selectCellTexts.remove(at: index)
                }
            } else {
                selectCellTexts.append(cellData[indexPath.row])
            }
            
        } else {
            if let index = selectCellTexts.firstIndex(of: cellData[indexPath.row]) {
                selectCellTexts.remove(at: index)
            }
        }
        
        if selectCellTexts.contains(where: { $0 == cellData[indexPath.row] }) {
            cell.selectAction()
        } else {
            cell.deselectAction()
        }
        
        print(cellData[indexPath.row])
        print(selectCellTexts)
        collectionView.reloadData()
    }
    
}
