//
//  PostsTests.swift
//  PostsTests
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import XCTest
import OHHTTPStubs
import ReactiveSwift
import Alamofire
import Result
import Nimble

@testable import PostsViewer

class PostsTests: InjectableBaseTestCase {

    lazy var postsManager = {
        return ServiceFactory.resolve(PostsManagerProtocol.self)
    }()

    override func setUp() {
        super.setUp()

        guard
            let server = appConfigurationService?.server,
            let host = server.host
        else { return }

        stub(condition: isHost(host) && pathEndsWith(Route.posts.path)  && isMethodGET()) { _ in
            let stubPath = OHPathForFile("posts.json", type(of: self))
            let data = try? Data(contentsOf: URL(fileURLWithPath: stubPath!))
            let response = OHHTTPStubsResponse(data: data!,
                                               statusCode: 200,
                                               headers: ["Content-type": "application/json"])

            return response
        }
        
    }

    override func tearDown() {
        super.tearDown()
        postsManager = nil
    }

    func test1FetchPostsFromInternet() {

        var postsList: [Post] = []

        // When
        postsManager?.getPosts().startWithResult { response in

            switch response.result {
            case .success(let posts):
                postsList.append(contentsOf: posts)

            case .failure(let error):
                APPLogger.error { "Fetch posts failed: \(error)" }
            }
        }

        // Then
        expect(postsList.count).toEventually(equal(100))
    }

    func test2FetchedPostsFromSavedCache() {

        var postsList: [Post] = []

        // When
        postsManager?.getPosts().startWithCompleted { [weak self] in

            guard
                let self = self,
                let posts: [Post] = self.databaseService?.getObjects()
            else { return }

            postsList.append(contentsOf: posts)
        }

        // Then
        expect(postsList.count).toEventually(equal(100))
    }

    func test3NoPostsAvailableOffline() {

        var postsList: [Post] = []

        // Given
        reachabilityService?.mutableIsNetworkAvailable.value = false

        // When
        postsManager?.getPosts().startWithCompleted { [weak self] in
            guard
                let posts: [Post] = self?.databaseService?.getObjects()
            else { return }
            postsList.append(contentsOf: posts)
        }

        // Then
        expect(postsList.count).toEventually(equal(0))
    }

    func test4SavedPostsAfterOnlineMode() {

        var postsList: [Post] = []

        // When
        postsManager?.getPosts().startWithCompleted { [weak self] in
            guard let self = self else { return }
            self.reachabilityService?.mutableIsNetworkAvailable.value = false

            self.postsManager?.getPosts().startWithResult { response in

                switch response.result {
                case .success(let posts):
                    postsList.append(contentsOf: posts)

                case .failure(let error):
                    APPLogger.error { "Fetch posts failed: \(error)" }
                }
            }
        }

        // Then
        expect(postsList.count).toEventually(equal(100))
    }
}
