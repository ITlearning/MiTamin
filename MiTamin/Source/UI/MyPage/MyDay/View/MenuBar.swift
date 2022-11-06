//
//  MenuBar.swift
//  iTamin
//
//  Created by Tabber on 2022/10/24.
//

import UIKit
import SnapKit

protocol MenuBarDelegate: class {
    func menuBar(scrollTo index: Int)
}

class MenuBar: UIView {

    weak var delegate: MenuBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configureTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryColor
        return view
    }()
    
    var indicatorViewLeadingConstraint:NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.cellId)
        
        collectionView.isScrollEnabled = false
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    func configureTabBar() {
        configureCollectionView()
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        self.addSubview(indicatorView)
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width/2)
        indicatorViewWidthConstraint.isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

extension MenuBar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.cellId, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.tabLabel.text = "데이노트"
        } else {
            cell.tabLabel.text = "위시리스트"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2 , height: 34)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.menuBar(scrollTo: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCollectionViewCell else { return }
        cell.tabLabel.textColor = .grayColor7
    }
}

extension MenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
