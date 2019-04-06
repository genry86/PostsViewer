//
//  AppConfigurationService.swift
//  PostsViewer
//
//  Created by Genry on 3/19/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Foundation

/// Service used to get indo from app config
protocol AppConfigurationServiceProtocol {
    /// Api server
    var server: URL? { get }
    /// Path to realm database file
    var dbPath: String? { get }
    /// Schema used for realm database
    var dbSchema: UInt64? { get }
    /// Delay alert after which top alert banner closed
    var delayAlertTimeout: Int? { get }
}

final class AppConfigurationService: AppConfigurationServiceProtocol {

    private let configFileName = "Config"
    private enum ConfigKey: String {
        case encryptDB = "ENCRYPT_DATABASE"
        case dbName = "DATABASE_NAME"
        case dbSchema = "DATABASE_SCHEMA"
        case apiUrl = "API_URL"
        case dismissAlertTiemout = "DISMISS_ALERT_TIMEOUT"
    }

    lazy var content: NSDictionary? = {
        guard
            let path = Bundle.main.path(forResource: configFileName, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path)
        else { return nil }
        return dict
    }()

    lazy var server: URL? = {
        guard
            let content = content,
            let urlString = content.object(forKey: ConfigKey.apiUrl.rawValue) as? String,
            let url = URL(string: urlString)
        else { return nil }
        return url
    }()

    lazy var dbName: String? = {
        guard
            let content = content,
            let name = content.object(forKey: ConfigKey.dbName.rawValue) as? String
        else { return nil }
        return name
    }()

    var dbPath: String? {
        guard
            let dbName = self.dbName
        else { return nil }

        do {
            let directory: URL = try FileManager.default.url(for: .documentDirectory,
                                                             in: .userDomainMask,
                                                             appropriateFor: nil,
                                                             create: true)

            let realmPath = (directory.path) + "/\(dbName).realm"
            return realmPath
        } catch {
            APPLogger.warning { "Invalid Realm Path" }
        }

        return nil
    }

    var dbSchema: UInt64? {
        guard
            let content = content,
            let configValue = content.object(forKey: ConfigKey.dbSchema.rawValue) as? String,
            let schema = UInt64(configValue)
        else { return nil }
        return schema
    }

    var delayAlertTimeout: Int? {
        guard
            let content = content,
            let configValue = content.object(forKey: ConfigKey.dismissAlertTiemout.rawValue) as? String,
            let timeout = Int(configValue)
            else { return nil }
        return timeout
    }
}
