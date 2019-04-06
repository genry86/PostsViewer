//
//  ServicesAssemblyTest.swift
//  PostsViewerTests
//
//  Created by Genry on 3/24/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Foundation
import UIKit
import Swinject

@testable import PostsViewer

final class ServicesAssemblyTest {

    static func register() {

        ServicesAssembly.register()

        ServiceFactory.container.autoregister(ReachabilityServiceProtocol.self, initializer: ReachabilityServiceMock.init)
            .inObjectScope(.container)
        ServiceFactory.container.autoregister(DatabaseServiceProtocol.self, initializer: DatabaseServiceMock.init)
            .inObjectScope(.container)
    }
}
