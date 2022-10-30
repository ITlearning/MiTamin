//
//  AddDayNoteViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/10/29.
//

import UIKit
import SnapKit
import CombineCocoa
import SkeletonView
import YPImagePicker
import Kingfisher

class AddDayNoteViewController: UIViewController {

    var viewModel = ViewModel()
    var cancelBag = CancelBag()
    var scrollView = UIScrollView()
    var datePickerView = CustomDatePickerView()
    var blackDemmedView = UIView()
    var alretView = AlertToastView()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicBold(size: 18)
        label.text = "fdsdfsdfds"
        label.isSkeletonable = true
        return label
    }()
    
    private let arrowDownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "downArrow")
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, arrowDownImage])
        stackView.spacing = 8
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openPopup))
        stackView.addGestureRecognizer(tapGesture)
        stackView.isSkeletonable = true
        return stackView
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        return collectionView
    }()
    
    private let borderView: UIView = {
        let bView = UIView()
        bView.backgroundColor = .white
        bView.layer.borderColor = UIColor.grayColor5.cgColor
        bView.layer.borderWidth = 1
        bView.layer.cornerRadius = 8
        
        return bView
    }()
    
    private let selectWishList: UILabel = {
        let label = UILabel()
        label.text = "완료한 위시리스트"
        label.textColor = UIColor.grayColor4
        label.font = UIFont.SDGothicMedium(size: 14)
        
        return label
    }()
    
    private let rightArrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-arrow-left-small-mono-1")
        
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.grayColor5.cgColor
        
        return textView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.SDGothicBold(size: 16)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stackView.startSkeletonAnimation()
        navigationItem.title = "기록 남기기"
        self.navigationController?.navigationBar.topItem?.title = "기록 남기기"
        navigationConfigure(title: "기록 남기기")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "기록 남기기"
        self.navigationController?.navigationBar.topItem?.title = "기록 남기기"
        viewModel.loadDays()
        startSkeleton()
        bindCombine()
        configureLayout()
        configureCollectionView()
    }
    
    func startSkeleton() {
        dateLabel.startSkeletonAnimation()
        dateLabel.showGradientSkeleton()
        arrowDownImage.startSkeletonAnimation()
        arrowDownImage.showGradientSkeleton()
    }
    
    func stopSkeleton() {
        dateLabel.stopSkeletonAnimation()
        dateLabel.hideSkeleton()
        arrowDownImage.stopSkeletonAnimation()
        arrowDownImage.hideSkeleton()
    }
    
    func bindCombine() {
        viewModel.$days
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                self.datePickerView.days = value
            })
            .cancel(with: cancelBag)
        
        viewModel.$currentDayPrint
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                
                if value != "" {
                    self.stackView.stopSkeletonAnimation()
                    self.stopSkeleton()
                }
                self.dateLabel.text = value
                
            })
            .cancel(with: cancelBag)
        
        viewModel.$firstDay
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                self?.datePickerView.selectDay = value
            })
            .cancel(with: cancelBag)
        
        viewModel.isWrite
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                if value {
                    self.alretView.showToastPopup(text: "이미 작성된 데이노트가 있어요!\n다른 날을 선택해주세요.")
                } else {
                    self.alretView.showToastPopup(text: "이미 작성된 데이노트가 있어요!\n다른 날을 선택해주세요.")
                }
            })
            .cancel(with: cancelBag)
        
        datePickerView.buttonSelect = { [weak self] printString, serverString in
            guard let self = self else { return }
            self.viewModel.currentDayPrint = printString
            self.viewModel.currentDay = serverString
            self.dismissAction()
        }
        
        doneButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.writeDayNote()
            })
            .cancel(with: cancelBag)
        
        textView.textPublisher
            .receive(on: DispatchQueue.main)
            .map{ $0 ?? "" }
            .assign(to: \.note, on: viewModel)
            .cancel(with: cancelBag)
        
        viewModel.$uploadSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                if value {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .cancel(with: cancelBag)
    }
    
    @objc
    func openPopup() {
        
        self.datePickerView.selectDayPrint = self.viewModel.currentDayPrint
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.datePickerView.snp.remakeConstraints {
                $0.bottom.equalTo(self.view.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(316)
            }
            self.datePickerView.alpha = 1.0
            self.blackDemmedView.alpha = 0.7
            self.datePickerView.superview?.layoutSubviews()
        })
    }
    
    @objc
    func dismissAction() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.datePickerView.snp.remakeConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(316)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(316)
            }
            self.datePickerView.alpha = 0.0
            self.blackDemmedView.alpha = 0.0
            self.datePickerView.superview?.layoutSubviews()
        })
    }
    
    @objc
    func wishListOpen() {
        let wishListVC = DoneWishListViewController(selectWishList: viewModel.selectWishList)
        
        self.navigationController?.pushViewController(wishListVC, animated: true)
        
        wishListVC.selectAction = { [weak self] value in
            guard let self = self else { return }
            self.viewModel.selectWishList = value
            self.selectWishList.text = value.wishText
        }
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AddPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AddPhotoCollectionViewCell.cellId)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.cellId)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func configureLayout() {
        blackDemmedView.backgroundColor = .black
        blackDemmedView.alpha = 0.0
        let tapGesutre = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        blackDemmedView.addGestureRecognizer(tapGesutre)
        view.addSubview(scrollView)
        datePickerView.alpha = 0.0
        scrollView.addSubview(stackView)
        view.addSubview(collectionView)
        let borderTap = UITapGestureRecognizer(target: self, action: #selector(wishListOpen))
        borderView.addGestureRecognizer(borderTap)
        view.addSubview(borderView)
        borderView.addSubview(selectWishList)
        borderView.addSubview(rightArrowView)
        view.addSubview(textView)
        view.addSubview(doneButton)
        
        view.addSubview(blackDemmedView)
        view.addSubview(datePickerView)
        
        blackDemmedView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        dateLabel.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.height.equalTo(20)
        }
        
        arrowDownImage.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(24)
            $0.leading.equalTo(scrollView.snp.leading).offset(20)
        }
        
        datePickerView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(316)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(316)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(130)
        }
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(48)
        }
        
        selectWishList.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.top).offset(16)
            $0.leading.equalTo(borderView.snp.leading).offset(16)
        }
        
        rightArrowView.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.top).offset(15)
            $0.trailing.equalTo(borderView.snp.trailing).inset(15)
            $0.width.equalTo(18)
            $0.height.equalTo(18)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(borderView)
            $0.height.equalTo(100)
        }
        
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(56)
        }
    }
    
    func selectPhoto() {
        var config = YPImagePickerConfiguration()
        config.wordings.libraryTitle = "갤러리"
        config.startOnScreen = .library
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "확인"
        config.library.maxNumberOfItems = 5
        config.library.defaultMultipleSelection = true
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking {[weak self] items, cancelled in
            guard let self = self else { return }
            var photoArray: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    photoArray.append(photo.image)
                case .video(let video):
                    break
                }
            }
            
            self.viewModel.selectImages += photoArray
            self.collectionView.reloadData()
            picker.dismiss(animated: true)
        }
        present(picker, animated: true)
    }
}

extension AddDayNoteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 2.5, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.selectImages.remove(at: indexPath.row)
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < viewModel.selectImages.count {
            
            let image = viewModel.selectImages[indexPath.row]
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.cellId, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
            cell.configureImage(image: image)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionViewCell.cellId, for: indexPath) as? AddPhotoCollectionViewCell else { return UICollectionViewCell() }
            
            cell.button.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: {[weak self] _ in
                    guard let self = self else { return }
                    self.selectPhoto()
                })
                .cancel(with: cancelBag)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}
