//
//  AppStartupService.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

/// Service, used to start and initialize other app's services
protocol AppStartupServiceProtocol {

    /// Initial controller used in App Delegate when app is starting
    var initialController: UIViewController? { get }

    /// Function to be called to perform any application-specific logic on application launch
    ///
    /// - Parameter completion: Callback called when service logic has completed
    func start(completion: (() -> Void)?)
}

final class AppStartupService: AppStartupServiceProtocol {

    // Services
    let reachabilityService: ReachabilityServiceProtocol
    private let navigationService: NavigationServiceProtocol

    // Initial Controller
    var initialController: UIViewController? {
        return ServiceFactory.initiateViewController(
            storyboardName: "Main",
            type: SplashViewController.self
        )
    }

    required init(reachabilityService: ReachabilityServiceProtocol,
                  navigationService: NavigationServiceProtocol) {
        self.reachabilityService = reachabilityService
        self.navigationService = navigationService
    }

    func start(completion: (() -> Void)? = .none) {
        reachabilityService.start()
        APPLogger.shared.start()
    }
}
