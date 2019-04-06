//
//  DbService.swift
//  PostsViewer
//
//  Created by Genry on 3/20/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import RealmSwift

/// Service for managing database loal data
protocol DatabaseServiceProtocol {

    /// Main realm instance
    var db: Realm? { get }

    /// Save single object
    func saveObject<T: Object>(object: T)
    /// Save list of objects
    func saveObjects<T: Object>(objects: [T])

    /// Fecthing single object
    func getObject<T: Object>(id: Any) -> T?
    /// Fetching list of objects
    func getObjects<T: Object>() -> [T]?
    /// Fetching list of object filtered by predicate
    func getObjects<T: Object>(filter: NSPredicate?) -> [T]?

    /// Deleting all objects from database
    func deleteAll()
}

class DatabaseService: DatabaseServiceProtocol {

    var dbConfiguration: Realm.Configuration?
    var db: Realm? {
        guard
            let configuration = dbConfiguration,
            let realm = try? Realm(configuration: configuration)
        else { return .none }
        return realm
    }

    init(appConfigurationService: AppConfigurationServiceProtocol) {
        guard
            let path = appConfigurationService.dbPath,
            let schema = appConfigurationService.dbSchema
        else { return }

        let fileURL = URL(fileURLWithPath: path)
        dbConfiguration = Realm.Configuration(fileURL: fileURL, schemaVersion: schema)
    }
}

// MARK: - Update

extension DatabaseService {

    func saveObject<T: Object>(object: T) {
        db?.add(object, update: true)
    }

    func saveObjects<T: Object>(objects: [T]) {
        try? db?.write {
            db?.add(objects, update: true)
        }
    }
}

// MARK: - Read

extension DatabaseService {

    func getObject<T: Object>(id: Any) -> T? {
        return db?.object(ofType: T.self, forPrimaryKey: id)
    }

    func getObjects<T: Object>() -> [T]? {
        return db?.objects(T.self).map { $0 }
    }

    func getObjects<T: Object>(filter: NSPredicate?) -> [T]? {
        guard let filter = filter else { return db?.objects(T.self).map { $0 } }
        return db?.objects(T.self).filter(filter).map { $0 }
    }
}

// MARK: - delete

extension DatabaseService {

    func deleteAll() {
        try? db?.write {
            db?.deleteAll()
        }
    }
}
