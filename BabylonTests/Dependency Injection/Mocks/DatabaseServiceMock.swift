//
//  DatabaseServiceMock.swift
//  PostsViewerTests
//
//  Created by Genry on 3/24/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Foundation
import Reachability
import ReactiveSwift
import Result
import UIKit
import RealmSwift

@testable import PostsViewer

class DatabaseServiceMock: DatabaseService {

    override init(appConfigurationService: AppConfigurationServiceProtocol) {
        super.init(appConfigurationService: appConfigurationService)
//        var uniqueConfiguration = Realm.Configuration.defaultConfiguration
//        uniqueConfiguration.inMemoryIdentifier = UUID().uuidString
//        Realm.Configuration.defaultConfiguration = uniqueConfiguration

//        dbConfiguration = Realm.Configuration(inMemoryIdentifier: UUID().uuidString)
    }
}
