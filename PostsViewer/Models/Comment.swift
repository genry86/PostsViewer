//
//  Comment.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class  Comment: Object, Mappable {

    @objc dynamic var id: Int = 0
    @objc dynamic var postId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var email: String?
    @objc dynamic var body: String?

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        postId <- map["postId"]
        name <- map["name"]
        email <- map["email"]
        body <- map["body"]
    }
}
