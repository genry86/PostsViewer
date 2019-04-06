//
//  User.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class User: Object, Mappable {

    @objc dynamic var id: Int = 0
    @objc dynamic var username: String = ""
    @objc dynamic var email: String?
    @objc dynamic var company: String?
    @objc dynamic var website: String?
    @objc dynamic var phone: String?

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        website <- map["website"]
        company <- map["company.name"]
        phone <- map["phone"]
        email <- map["email"]
    }
}
