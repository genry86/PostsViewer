//
//  CommentModelTests.swift
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

class CommentModelTests: XCTestCase {

    var comments: [Comment] = {
        guard let json = FileLoader.loadJSON(name: "comments") else { return [] }
        return Mapper().mapArray(JSONObject: json.arrayObject) ?? []
    }()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1AllCommentsMapped() {
        expect(self.comments.count).to(equal(500))
    }

    func test2CommentFieldsMapped() {
        guard
            let comment = self.comments.first
        else { return}

        expect(comment.id).to(equal(1))
        expect(comment.postId).to(equal(1))
        expect(comment.name).to(equal("id labore ex et quam laborum"))
        expect(comment.email).to(equal("Eliseo@gardner.biz"))
        expect(comment.body).to(equal("laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"))
    }
}
