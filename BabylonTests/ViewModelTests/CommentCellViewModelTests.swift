//
//  CommentCellViewModelTests.swift
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

class CommentCellViewModelTests: XCTestCase {

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

    func testCommentDataBinded() {
        guard
            let comment = self.comments.first
        else { return}

        let commentCellViewModel = CommentCellViewModel(for: comment)

        expect(commentCellViewModel.comment.value).to(equal("laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"))
        expect(commentCellViewModel.email.value).to(equal("Eliseo@gardner.biz"))
    }
}
