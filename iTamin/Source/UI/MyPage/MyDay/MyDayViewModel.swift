//
//  MyDayViewModel.swift
//  iTamin
//
//  Created by Tabber on 2022/10/26.
//

import Foundation

extension MyDayViewController {
    class ViewModel: ObservableObject {
        
        @Published var wishList: [WishListModel] = []
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        
        func getWishList() {
            networkManager.getWishList()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    self.wishList = value.data
                })
                .cancel(with: cancelBag)
        }
        
        func addWishList(text: String) {
            networkManager.addWishList(text: text)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    
                    self.wishList.append(value.data)
                    
                    print(value.message)
                    
                })
                .cancel(with: cancelBag)
        }
        
        func editWishList(item: WishListModel) {
            networkManager.editWishList(wishId: item.wishId, text: item.wishText)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { error in
                    switch error {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("완료")
                    }
                }, receiveValue: { value in
                    print(value.message)
                })
                .cancel(with: cancelBag)
        }
        
        func deleteWishList(idx: Int) {
            networkManager.deleteWishList(wishId: idx)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { error in
                    switch error {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("완료")
                    }
                }, receiveValue: { value in
                    print(value.message)
                })
                .cancel(with: cancelBag)
        }
    }
}
