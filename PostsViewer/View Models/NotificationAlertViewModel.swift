//
//  NotificationAlertViewModel.swift
//  PostsViewer
//
//  Created by Genry on 3/20/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import ReactiveSwift

/// ViewModel used on top sliding alert view
protocol NotificationAlertViewModelProtocol {
    /// Delay in seconds, used for closing banner
    var delayBeforeClose: Property<Int> { get }
    /// Internet connection status
    var networkConnectionOpen: Property<Bool> { get }
}

final class NotificationAlertViewModel: NotificationAlertViewModelProtocol {

    private let mutableDelayBeforeClose = MutableProperty<Int>(5)
    lazy var delayBeforeClose: Property<Int> = Property<Int>(capturing: mutableDelayBeforeClose)

    private let mutableNetworkConnectionOpen = MutableProperty<Bool>(true)
    lazy var networkConnectionOpen: Property<Bool> = Property<Bool>(capturing: mutableNetworkConnectionOpen)

    // Services
    private let reachabilityService: ReachabilityServiceProtocol
    private let appConfigurationService: AppConfigurationServiceProtocol

    init(reachabilityService: ReachabilityServiceProtocol,
         appConfigurationService: AppConfigurationServiceProtocol) {
        self.reachabilityService = reachabilityService
        self.appConfigurationService = appConfigurationService

        setupBindings()
        setupAlertSettings()
    }
}

// MARK: - Private

private extension NotificationAlertViewModel {

    func setupBindings() {
        mutableNetworkConnectionOpen <~ reachabilityService.isNetworkAvailable
    }

    func setupAlertSettings() {
        guard let delayAlertTimeout = appConfigurationService.delayAlertTimeout else { return }
        mutableDelayBeforeClose.value = delayAlertTimeout
    }
}
