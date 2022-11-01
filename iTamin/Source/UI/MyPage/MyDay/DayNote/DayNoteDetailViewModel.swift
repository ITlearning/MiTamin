//
//  DayNoteDetailViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/11/01.
//

import Foundation
import Combine
import UIKit
import Kingfisher

extension DayNoteDetailViewController {
    class ViewModel: ObservableObject {
        @Published var downloadedImage: [UIImage] = []
        @Published var dayNoteModel: DayNoteModel? = nil
        @Published var editWishList: WishListModel? = nil
        var downloadIsDone: Bool = false
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        func downLoadImage() {
            
            downloadedImage.removeAll()
            DispatchQueue.global(qos: .utility).async {
                self.dayNoteModel?.imgList.forEach({ url in
                    let resource = ImageResource(downloadURL: URL(string: url)!)
                    KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil)  { result in
                        switch result {
                        case .success(let value):
                            self.downloadedImage.append(value.image)
                            print("Image: \(value.image). Got from: \(value.cacheType)")
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                })
            }
        }
    }
}
