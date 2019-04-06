//
//  Post.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Post: Object, Mappable {

    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String?
    @objc dynamic var viewed = false

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["userId"]
        title <- map["title"]
        body <- map["body"]
    }
}
