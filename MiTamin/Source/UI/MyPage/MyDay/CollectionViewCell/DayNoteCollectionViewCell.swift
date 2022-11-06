//
//  DayNoteCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import UIKit
import SnapKit
import SwiftUI

protocol DayNoteDeletgate: AnyObject {
    func selectIndexPath(indexPath: IndexPath)
}

class DayNoteCollectionViewCell: UICollectionViewCell {
    static let cellId = "DayNoteCollectionViewCell"
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    weak var delegate: DayNoteDeletgate?
    
    var dayNotes: [DayNoteListModel] = [] {
        didSet {
            setView(isShow: dayNotes.count != 0)
            collectionView.reloadData()
        }
    }

    private let dayNoteMainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 마이데이에는\n어떤 추억을 쌓게 될까요?"
        label.textAlignment = .left
        label.font = UIFont.SDGothicBold(size: 24)
        label.numberOfLines = 0
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    private let mainillustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Mainillustration")
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private let notWriteMainLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 작성된\n마이데이 노트가 없어요."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.SDGothicBold(size: 18)
        label.textColor = UIColor.grayColor4
        label.isSkeletonable = true
        return label
    }()
    
    private let notWriteSubLabel: UILabel = {
        let label = UILabel()
        label.text = "마이데이를 기록해주세요!"
        label.numberOfLines = 0
        label.font = UIFont.SDGothicMedium(size: 16)
        label.textColor = UIColor.grayColor3
        label.isSkeletonable = true
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.itemSize = CGSize(width: 105, height: 105)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.alpha = 0.0
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setView(isShow: Bool) {
        if isShow {
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.mainillustrationImageView.alpha = 0.0
                self.notWriteMainLabel.alpha = 0.0
                self.notWriteSubLabel.alpha = 0.0
                self.collectionView.alpha = 1.0
            })
            
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.mainillustrationImageView.alpha = 1.0
                self.notWriteMainLabel.alpha = 1.0
                self.notWriteSubLabel.alpha = 1.0
                self.collectionView.alpha = 0.0
            })
        }
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DayNoteListCollectionViewCell.self, forCellWithReuseIdentifier: DayNoteListCollectionViewCell.cellId)
        collectionView.register(DayNoteHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DayNoteHeaderCollectionReusableView.cellId)
    }
    
    func configureLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(dayNoteMainTitleLabel)
        scrollView.addSubview(mainillustrationImageView)
        scrollView.addSubview(notWriteMainLabel)
        scrollView.addSubview(notWriteSubLabel)
        scrollView.addSubview(collectionView)
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        dayNoteMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(40)
            $0.leading.equalTo(scrollView.snp.leading).offset(20)
        }
        
        mainillustrationImageView.snp.makeConstraints {
            $0.top.equalTo(dayNoteMainTitleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
        
        notWriteMainLabel.snp.makeConstraints {
            $0.top.equalTo(mainillustrationImageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        notWriteSubLabel.snp.makeConstraints {
            $0.top.equalTo(notWriteMainLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(scrollView.snp.bottom).inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dayNoteMainTitleLabel.snp.bottom).offset(40)
            $0.leading.equalTo(dayNoteMainTitleLabel.snp.leading)
            $0.trailing.equalTo(dayNoteMainTitleLabel.snp.trailing)
            $0.bottom.equalTo(self.snp.bottom)
        }
    }
    
}


extension DayNoteCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dayNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayNotes[section].data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectIndexPath(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusebleView: UICollectionReusableView? = nil
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DayNoteHeaderCollectionReusableView.cellId, for: indexPath) as! DayNoteHeaderCollectionReusableView
            
            headerView.setHeader(title: dayNotes[indexPath.section].year+"년")
            headerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 40)

            reusebleView = headerView
        }
        
        guard let reusebleView = reusebleView else {
            return UICollectionReusableView()
        }
        
        return reusebleView

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayNoteListCollectionViewCell.cellId, for: indexPath) as? DayNoteListCollectionViewCell else { return UICollectionViewCell() }
        let item = dayNotes[indexPath.section].data[indexPath.row]
        cell.setItem(month: "\(item.month)월", image: item.imgList.first ?? "")
        
        return cell
    }
    
    
}
