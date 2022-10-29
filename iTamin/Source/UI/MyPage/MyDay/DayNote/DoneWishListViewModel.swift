//
//  DoneWishListViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import Foundation
import Combine

extension DoneWishListViewController {
    class ViewModel: ObservableObject {
        @Published var wishList: [WishListModel] = []
        @Published var selectWishList: WishListModel? = nil
        var cancelBag = CancelBag()
        var networkManger = NetworkManager()
        
        func getWishList() {
            networkManger.getWishList()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                    
                    guard let self = self else { return }
                    
                    self.wishList = value.data
                    
                })
                .cancel(with: cancelBag)
        }
        
    }
}
