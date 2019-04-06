//
//  UserModelTests.swift
//  PostsViewerTests
//
//  Created by Genry on 3/25/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import XCTest
import Nimble
import ObjectMapper
import SwiftyJSON

@testable import PostsViewer

class UserModelTests: XCTestCase {

    var users: [User] = {
        guard let json = FileLoader.loadJSON(name: "users") else { return [] }
        return Mapper().mapArray(JSONObject: json.arrayObject) ?? []
    }()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1AllUsersMapped() {
        expect(self.users.count).to(equal(10))
    }

    func test2UserFieldsMapped() {
        guard
            let user = self.users.first
        else { return}

        expect(user.id).to(equal(1))
        expect(user.username).to(equal("Bret"))
        expect(user.email).to(equal("Sincere@april.biz"))
        expect(user.company).to(equal("Romaguera-Crona"))
        expect(user.website).to(equal("hildegard.org"))
        expect(user.phone).to(equal("1-770-736-8031 x56442"))
    }
}
