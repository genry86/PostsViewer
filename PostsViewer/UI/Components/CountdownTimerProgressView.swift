//
//  CountdownTimerProgressView.swift
//  PostsViewer
//
//  Created by Genry on 3/17/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 Custom countdown timer progress view.
 Call `startCounting()` with default or own values. observe `timeoutReached` property

 - Example
 ````
 countdownTimerProgressView.startCounting()

 countdownTimerProgressView.timeoutReached.producer.skipNil().startWithValues { reached in
 print("\(reached)")
 }
 ````

 - Parameter timeoutReached: main reactive parameter to catch timeout
 */

final class CountdownTimerProgressView: UIView {

    struct CircleStyle {
        var lineWidth: CGFloat
        var lineColor: CGColor
        static let `default` = CircleStyle(lineWidth: 10, lineColor: UIColor.gold.cgColor)
    }

    private lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.font = label.font.withSize(40.0)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        return label
    }()

    private var counterTimer: Timer?
    private var animationStarted = false

    private let mutableTimeoutReached = MutableProperty<Bool?>(.none)
    lazy var timeoutReached = Property<Bool?>(mutableTimeoutReached)

    private var remainingTime = 0.0 {
        didSet {
            countdownLabel.text = Int(remainingTime).description
        }
    }

    deinit {
        stopCounting()
    }
}

// MARK: - Public

extension CountdownTimerProgressView {

    func startCounting(with remainingTimeInterval: CFTimeInterval = 5, style: CircleStyle = .default) {
        guard !animationStarted else { return }

        animationStarted = true
        remainingTime = remainingTimeInterval

        startTimer()
        startCircleAnimations(style: style)
    }

    func startCircleAnimations(style: CircleStyle) {
        let centerPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = frame.height / 2

        let circlePath = UIBezierPath(arcCenter: centerPoint,
                                      radius: radius,
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat.pi * 2,
                                      clockwise: true)

        // Path of Circle
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.strokeStart = 0.0
        circleShape.strokeEnd = 1.0
        circleShape.lineWidth = style.lineWidth
        circleShape.strokeColor = style.lineColor
        circleShape.fillColor = UIColor.clear.cgColor

        // Rotate circle to set most top point as start
        circleShape.bounds = bounds
        circleShape.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        circleShape.position = CGPoint(x: 0.0, y: frame.height)
        circleShape.transform = CATransform3DMakeRotation(-90.radians, 0, 0, 1)

        // Animation for stroke from end to start
        let counterTimeCircleAnimation = CABasicAnimation(keyPath: "strokeEnd")
        counterTimeCircleAnimation.duration = remainingTime
        counterTimeCircleAnimation.fromValue = 1.0
        counterTimeCircleAnimation.toValue = 0.0
        counterTimeCircleAnimation.fillMode = .forwards
        counterTimeCircleAnimation.isRemovedOnCompletion = false
        circleShape.add(counterTimeCircleAnimation, forKey: .none)

        layer.addSublayer(circleShape)
    }
}

// MARK: - Timer

private extension CountdownTimerProgressView {

    func startTimer() {
        counterTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                            target: self,
                                            selector: #selector(fireTimer),
                                            userInfo: .none,
                                            repeats: true)
        countdownLabel.isHidden = false
    }

    @objc func fireTimer() {
        guard
            remainingTime > 0
        else {
            stopCounting()
            animationStarted = false
            mutableTimeoutReached.value = true
            return
        }
        remainingTime -= 1
        countdownLabel.text = Int(remainingTime).description
    }

    func stopCounting() {
        countdownLabel.isHidden = true
        counterTimer?.invalidate()
        counterTimer = nil
    }
}
