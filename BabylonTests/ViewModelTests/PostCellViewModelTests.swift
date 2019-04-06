//
//  PostCellViewModelTests.swift
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

class PostCellViewModelTests: XCTestCase {

    var posts: [Post] = {
        guard let json = FileLoader.loadJSON(name: "posts") else { return [] }
        return Mapper().mapArray(JSONObject: json.arrayObject) ?? []
    }()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPostDataBinded() {
        guard
            let post = self.posts.first
        else { return}

        let postCellViewModel = PostCellViewModel(for: post)

        expect(postCellViewModel.id.value).to(equal(1))
        expect(postCellViewModel.title.value).to(equal("sunt aut facere repellat provident occaecati excepturi optio reprehenderit"))
        expect(postCellViewModel.body.value).to(equal("quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"))
    }
}
