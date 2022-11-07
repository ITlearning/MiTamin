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
        @Published var dayNoteList: [DayNoteListModel] = []
        var networkManager = NetworkManager()
        var cancelBag = CancelBag()
        var selectIdx: Int = 0
        @Published var loading: Bool = false
        func getDayNoteList() {
            networkManager.getDayNoteList()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    self.dayNoteList.removeAll()
                    value.data.forEach { (key, value) in
                        self.dayNoteList.append(DayNoteListModel(year: key, data: value))
                    }
                })
                .cancel(with: cancelBag)
        }
        
        func getWishList() {
            
            self.wishList.removeAll()
            networkManager.getWishList()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    self.wishList = value.data
                })
                .cancel(with: cancelBag)
        }
        
        func addWishList(text: String) {
            loading = true
            networkManager.addWishList(text: text)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                    self.loading = false
                }, receiveValue: { value in
                    self.loading = false
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
            loading = true
            networkManager.deleteWishList(wishId: idx)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { error in
                    switch error {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("완료")
                    }
                    self.loading = false
                }, receiveValue: { value in
                    self.loading = false
                    print(value.message)
                })
                .cancel(with: cancelBag)
        }
    }
}
