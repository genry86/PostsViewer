//
//  PeopleNearbyNotificationAlertView.swift
//  Xapo
//
//  Created by Genry on 1/5/19.
//  Copyright © 2019 Xapo. All rights reserved.
//

import UIKit
import ReactiveSwift

/// Alert View presented on top of screens with slide effect
final class NotificationAlertView: UIView {

    /// icon image to present network status
    @IBOutlet weak var iconImageView: UIImageView!
    /// title lable 'online' or 'offline'
    @IBOutlet weak var titleLabel: UILabel!

    /// self view to manipulate with banner
    @IBOutlet weak var bannerView: UIView!

    /// Constraint used for slide animation
    @IBOutlet weak var topBannerConstraint: NSLayoutConstraint!

    var originalCenter = CGPoint.zero
    var originalTopConstant = 0
    var completion: (() -> Void)?

    var viewModel: NotificationAlertViewModelProtocol?
}

// MARK: - Public

extension NotificationAlertView {

    func setupViewModel(viewModel: NotificationAlertViewModelProtocol) {
        self.viewModel = viewModel
        setupBindings()
        setupAppearence()
        setupConstraints()
    }

    func slideDown() {
        frame.origin.y = -frame.height
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let view = self else { return }
            var rect = view.frame
            rect.origin.y = 0
            view.frame = rect
            }
        )
    }
}

// MARK: - Private

private extension NotificationAlertView {

    func setupConstraints() {
        guard let parentView = superview else { return }

        let parentViewAnchors = parentView.layoutMarginsGuide
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentViewAnchors.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentViewAnchors.trailingAnchor),
            topAnchor.constraint(equalTo: parentView.topAnchor)
        ])
        setNeedsLayout()
    }

    func setupBindings() {
        guard let viewModel = viewModel else { return }

        titleLabel.reactive.text <~ viewModel.networkConnectionOpen
            .map { connectionOpen in
                return connectionOpen ? "alert-view.online.title".localized : "alert-view.offline.title".localized
        }

        iconImageView.reactive.image <~ viewModel.networkConnectionOpen
            .map { networkConnectionOpen in
                return networkConnectionOpen ? #imageLiteral(resourceName: "online_status") : #imageLiteral(resourceName: "offline_status")
            }
    }

    func setupAppearence() {
        guard let viewModel = viewModel else { return }

        dismissAfterDelay(delayTime: viewModel.delayBeforeClose.value)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        bannerView.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(gesture:)))
        addGestureRecognizer(panGesture)
        originalCenter = center
    }

    func dismissAfterDelay(delayTime: Int) {
        let dismissTime = DispatchTime.now() + .seconds(delayTime)
        DispatchQueue.main.asyncAfter(deadline: dismissTime) { [weak self] in
            self?.removeWithSlideUp()
        }
    }

    @objc func tapAction(sender: UITapGestureRecognizer) {
        completion?()
        removeWithSlideUp()
    }

    @objc func panAction(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let resultTopConstant = topBannerConstraint.constant + translation.y

        guard resultTopConstant < 0 else { return }

        if gesture.state == .changed {
            topBannerConstraint.constant = translation.y
        } else if gesture.state == .ended, abs(topBannerConstraint.constant) > 30 {
            removeWithSlideUp()
        }
    }

    func removeWithSlideUp() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let view = self else { return }
            var rect = view.frame
            rect.origin.y = -rect.height
            view.frame = rect
            }, completion: { [weak self] animationComplete in
                if animationComplete {
                    self?.removeFromSuperview()
                }
        })
    }
}
