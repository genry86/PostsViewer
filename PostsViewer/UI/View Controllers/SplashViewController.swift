//
//  ViewController.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit
import ReactiveSwift

/// Initial Controller used for animation purpose.
final class SplashViewController: ReactiveViewController<SplashViewModelProtocol> {

    /// Main Title in the center
    @IBOutlet weak var titleLabel: UILabel!
    /// Animated progress indicator componnent
    @IBOutlet weak var counterView: CountdownTimerProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        applyStyles()
        counterView.startCounting()
        setupLocalization()
    }
}

// MARK: - Private

private extension SplashViewController {

    func setupLocalization() {
        titleLabel.text = "splash-screen.title".localized
    }

    func applyStyles() {
        titleLabel.apply(style: .appTitle)
    }

    func setupBindings() {
        counterView.timeoutReached.producer.skipNil().startWithValues { [weak self] _ in
            guard
                let self = self,
                let viewModel = self.viewModel
            else { return }

            viewModel.openPostsScreen.apply().start()
        }
    }
}
