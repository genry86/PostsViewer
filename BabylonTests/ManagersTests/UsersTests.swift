//
//  UsersTests.swift
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

class UsersTests: InjectableBaseTestCase {

    private let userId = 1

    lazy var usersManager = {
        return ServiceFactory.resolve(UsersManagerProtocol.self)
    }()

    override func setUp() {
        super.setUp()

        guard
            let server = appConfigurationService?.server,
            let host = server.host
        else { return }

        stub(condition: isHost(host) && pathEndsWith(Route.user(id: userId).path)  && isMethodGET()) { _ in
            let stubPath = OHPathForFile("users.json", type(of: self))
            let data = try? Data(contentsOf: URL(fileURLWithPath: stubPath!))
            let response = OHHTTPStubsResponse(data: data!,
                                               statusCode: 200,
                                               headers: ["Content-type": "application/json"])

            return response
        }

    }

    override func tearDown() {
        super.tearDown()
        usersManager = nil
    }

    func test1FetchUser() {

        var user: User?
        usersManager?.getUser(id: userId)
            .observe(on: QueueScheduler.main)
            .startWithCompleted { [weak self] in
                guard
                    let self = self,
                    let userInfo: User = self.databaseService?.getObject(id: self.userId)
                else { return }
                user = userInfo
        }

        // then
        expect(user).toNotEventually(beNil())
        expect(user?.username).toEventually(equal("Bret"))
        expect(user?.company).toEventually(equal("Romaguera-Crona"))
        expect(user?.email).toEventually(equal("Sincere@april.biz"))
        expect(user?.website).toEventually(equal("hildegard.org"))
    }
}
