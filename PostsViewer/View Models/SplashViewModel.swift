//
//  SplashViewModel.swift
//  PostsViewer
//
//  Created by Genry on 3/23/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import ReactiveSwift
import Result

/// ViewModel for initial splash screen
protocol SplashViewModelProtocol {
    /// Action to open posts list
    var openPostsScreen: Action<(), (), NoError> { get }
}

final class SplashViewModel: SplashViewModelProtocol {

    // Actions
    lazy var openPostsScreen: Action<(), (), NoError> = Action<(), (), NoError>(execute: handleOpenPostsScreen)

    // Services
    private let navigationService: NavigationServiceProtocol

    init(navigationService: NavigationServiceProtocol) {
        self.navigationService = navigationService
    }
}

// MARK: - Private

private extension SplashViewModel {

    func handleOpenPostsScreen() -> SignalProducer<(), NoError> {
        return SignalProducer { [weak self] observer, _ in
            guard let self = self else { return observer.sendInterrupted() }
            self.navigationService.navigate(to: VCRouter.postList.url)
            observer.sendCompleted()
        }
    }
}
