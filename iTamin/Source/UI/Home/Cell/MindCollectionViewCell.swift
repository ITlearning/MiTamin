//
//  MindCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/10/08.
//

import UIKit
import SwiftUI
import SnapKit
import Combine

class MindSelectViewModel: ObservableObject {
    var selectIndex = CurrentValueSubject<Int, Never>(UserDefaults.standard.integer(forKey: .mindSelectIndex))
    @Published var index: Int = 0
    
    
    private let cancellable = UserDefaults.standard.publisher(for: \.userValue).sink(receiveValue: { value in
        print("가가ㅏ각",value)
    })
    
}

class MindCollectionViewCell: UICollectionViewCell {
    
    @ObservedObject var viewModel = MindSelectViewModel()
    
    static let cellId: String = "MindCollectionViewCell"
    
    var buttonClick: ((Int) -> ())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureCell() {
        
        let mindView = UIHostingController(rootView: MindSelectView(viewModel: self.viewModel, selectMindImage: $viewModel.index))
        
        let mainSubTitleView = UIHostingController(rootView: MainSubTitleView(mainTitle: "3. 하루 진단하기",
                                                                              subTitle: "오늘의 마음 컨디션은 어떤가요?"))
        mindView.rootView.buttonClickIndex = { idx in
            self.buttonClick?(idx)
        }
        
        addSubview(mainSubTitleView.view)
        addSubview(mindView.view)
        
        mainSubTitleView.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        mindView.view.snp.makeConstraints {
            $0.top.equalTo(mainSubTitleView.view.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        
        
    }
    
    
}
