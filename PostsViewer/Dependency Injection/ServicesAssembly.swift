//
//  ServicesAssembly.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import SwinjectAutoregistration

final class ServicesAssembly {

    static func register() {
        ServiceFactory.container.autoregister(ReachabilityServiceProtocol.self, initializer: ReachabilityService.init)
            .inObjectScope(.container)
        ServiceFactory.container.autoregister(AppStartupServiceProtocol.self, initializer: AppStartupService.init)
            .inObjectScope(.container)
        ServiceFactory.container.autoregister(AppConfigurationServiceProtocol.self, initializer: AppConfigurationService.init)
            .inObjectScope(.container)
        ServiceFactory.container.autoregister(APIServiceProtocol.self, initializer: APIService.init)
            .inObjectScope(.container)
        ServiceFactory.container.autoregister(DatabaseServiceProtocol.self, initializer: DatabaseService.init)
            .inObjectScope(.container)
        ServiceFactory.container.autoregister(NavigationServiceProtocol.self, initializer: NavigationService.init)
            .inObjectScope(.container)
    }
}
