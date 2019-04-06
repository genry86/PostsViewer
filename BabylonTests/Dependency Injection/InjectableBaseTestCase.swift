//
//  InjectableBaseTestCase.swift
//  PostsViewerTests
//
//  Created by Genry on 3/24/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Foundation
import XCTest
import Swinject
import RealmSwift

@testable import PostsViewer

class InjectableBaseTestCase: XCTestCase {

    lazy var reachabilityService = {
        return ServiceFactory.resolve(ReachabilityServiceProtocol.self) as? ReachabilityServiceMock
    }()

    lazy var appConfigurationService = {
        return ServiceFactory.resolve(AppConfigurationServiceProtocol.self)
    }()

    lazy var databaseService = {
        return ServiceFactory.resolve(DatabaseServiceProtocol.self)
    }()

    lazy var navigationService = {
        return ServiceFactory.resolve(NavigationServiceProtocol.self)
    }()

    override func setUp() {
        super.setUp()
        ServicesAssemblyTest.register()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDown() {
        super.tearDown()
        databaseService?.deleteAll()
        reachabilityService = nil
        appConfigurationService = nil
        databaseService = nil
    }
}
