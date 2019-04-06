//
//  ReachabilityService.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Reachability
import ReactiveSwift
import Result

/// Service used to get network status info
protocol ReachabilityServiceProtocol {

    /// Flag used to detect if internet available
    var isNetworkAvailable: Property<Bool> { get }

    /// Function to be called to perform the check of reachability.
    /// Note: If the internet connection is failing then a view controller will be presented blocking any user interactions.
    func start()
}

final class ReachabilityService: ReachabilityServiceProtocol {

    private let mutableIsNetworkAvailable = MutableProperty<Bool>(true)
    lazy var isNetworkAvailable: Property<Bool> = Property<Bool>(capturing: mutableIsNetworkAvailable)

    lazy var navigationService: NavigationServiceProtocol = {
        return ServiceFactory.resolve(NavigationServiceProtocol.self)!
    }()

    private let service = Reachability.init()

    func start() {
        service?.whenReachable = { [weak self] _ in
            self?.networkAvailable()
        }
        service?.whenUnreachable = { [weak self] _ in
            self?.networkUnavailable()
        }

        do {
            try service?.startNotifier()
        } catch {
            APPLogger.debug { "Unable to start notifier" }
        }
    }

    func networkAvailable() {
        mutableIsNetworkAvailable.value = true
        navigationService.navigate(to: VCRouter.notificationAlert.url)
    }

    func networkUnavailable() {
        mutableIsNetworkAvailable.value = false
        navigationService.navigate(to: VCRouter.notificationAlert.url)
    }
}
