//
//  CommentsTests.swift
//  PostsViewerTests
//
//  Created by Genry on 3/25/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import XCTest
import OHHTTPStubs
import ReactiveSwift
import Alamofire
import Result
import Nimble

@testable import PostsViewer

class CommentsTests: InjectableBaseTestCase {

    private let postId = 1

    lazy var commentsManager = {
        return ServiceFactory.resolve(CommentsManagerProtocol.self)
    }()

    override func setUp() {
        super.setUp()

        guard
            let server = appConfigurationService?.server,
            let host = server.host
            else { return }

        stub(condition: isHost(host) && pathEndsWith(Route.comments(postId: postId).path)  && isMethodGET()) { _ in
            let stubPath = OHPathForFile("comments.json", type(of: self))
            let data = try? Data(contentsOf: URL(fileURLWithPath: stubPath!))
            let response = OHHTTPStubsResponse(data: data!,
                                               statusCode: 200,
                                               headers: ["Content-type": "application/json"])

            return response
        }

    }

    override func tearDown() {
        super.tearDown()
        commentsManager = nil
    }

    func test1FetchComments() {

        var comments: [Comment] = []
        commentsManager?.getComments(postId: postId)
            .observe(on: QueueScheduler.main)
            .startWithCompleted { [weak self] in
                guard
                    let self = self,
                    let postsComments: [Comment] = self.databaseService?
                        .getObjects(filter: NSPredicate(format: "postId == %d", self.postId))
                else { return }
                comments.append(contentsOf: postsComments)
        }

        // then
        expect(comments.count).toEventually(equal(5))
    }
}
