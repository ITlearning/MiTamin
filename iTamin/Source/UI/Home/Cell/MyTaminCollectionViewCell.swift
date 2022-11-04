//
//  MyTaminCollectionViewCell.swift
//  iTamin
//
//  Created by Tabber on 2022/09/29.
//

import UIKit
import SwiftUI
import SnapKit
import Combine
import CombineCocoa

enum TimerStatus {
    case start
    case pause
    case end
}

protocol MyTaminCollectionViewDelegate: AnyObject {
    func nextOn()
    func buttonStatus(timer: TimerStatus)
}

class MyTaminCollectionViewCell: UICollectionViewCell {
    static let cellId = "MyTaminCollectionViewCell"
    
    let containerView: UIView = {
        let containView = UIView()
        containView.backgroundColor = .clear
        
        return containView
    }()
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myTaminTimerImage")
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    weak var delegate: MyTaminCollectionViewDelegate?
    //var timer: Timer?
    var timer: DispatchSourceTimer?
    
    var totalTime: Int = 0
    var currentTime: Int = 0
    var cancelBag = CancelBag()
    var timerStatus: TimerStatus = .start
    
    var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.SDGothicBold(size: 40)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PlayButton"), for: .normal)
        button.setImage(UIImage(named: "Stopbutton"), for: .selected)
        return button
    }()
    
    let mainTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicBold(size: 24)
        label.textColor = UIColor.grayColor4
        
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.SDGothicRegular(size: 14)
        label.textColor = UIColor.grayColor3
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let timerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myTaminTimerImage")
        
        return imageView
    }()
    
    var isDone: Bool = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellLayout()
        bindCombine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindCombine() {
        playButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] _ in
                guard let self = self else { return }
                self.startOtpTimer()
                self.delegate?.buttonStatus(timer: self.timerStatus)
            })
            .cancel(with: cancelBag)
    }
    
    private func configureCellLayout() {
        addSubview(containerView)
        
        containerView.addSubview(timerImageView)
        containerView.addSubview(timerLabel)
        containerView.addSubview(playButton)
        containerView.addSubview(mainTitle)
        containerView.addSubview(subTitle)
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        timerImageView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(30)
            $0.centerX.equalTo(containerView.snp.centerX)
            $0.width.equalTo(218)
            $0.height.equalTo(218)
        }
     
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(timerImageView.snp.top).offset(40)
            $0.centerX.equalTo(containerView.snp.centerX)
        }
        
        playButton.snp.makeConstraints {
            $0.top.equalTo(timerImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(timerImageView.snp.centerX)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(playButton.snp.bottom).offset(40)
            $0.centerX.equalTo(containerView.snp.centerX)
        }

        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(20)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(21)
        }
        
    }
    
    func configureCell(index: Int, model: MyTaminModel) {
        timerImageView.image = UIImage(named: model.image)
        
        self.mainTitle.text = "\(index+1). "+model.mainTitle
        self.subTitle.text = model.subTitle
        self.totalTime = model.TotalTime ?? 0
        self.timerLabel.text = self.timeFormatted(self.totalTime)
        self.currentTime = model.TotalTime ?? 0
        self.isDone = model.isDone
        
        if model.isDone {
            self.delegate?.nextOn()
        }
        
    }

    func startOtpTimer() {
        if timer == nil {
            // 1
            self.currentTime = totalTime
            timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            // 2
            timer?.schedule(deadline: .now(), repeating: 1)
            
            timer?.setEventHandler(handler: {
                self.timerLabel.text = self.timeFormatted(self.currentTime)
                
                if self.currentTime != 0 {
                    self.currentTime -= 1 // decrease counter timer
                }
                else {
                    if let timer = self.timer {
                        self.timerStatus = .end
                        timer.cancel()
                        self.restartButton(reset: true)
                        self.timer = nil
                        self.delegate?.nextOn()
                    }
                }
            })
            self.timerStatus = .start
            timer?.resume()
            self.restartButton()
        } else {
            if timerStatus == .start {
                timerStatus = .pause
                timer?.suspend()
            } else if timerStatus == .pause {
                timerStatus = .start
                timer?.resume()
            }
            
            self.restartButton()
        }
    }

    func restartButton(reset: Bool = false) {
        if reset {
            playButton.setImage(UIImage(named: "Restartbutton"), for: .normal)
        } else {
            playButton.setImage(UIImage(named: timerStatus == .pause ? "PlayButton" : "Stopbutton"), for: .normal)
        }
        
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
