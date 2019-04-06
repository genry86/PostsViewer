//
//  Router.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Alamofire

/// Route enum used to fetch data from external server
enum Route: URLRequestConvertible {

    case posts
    case users
    case user(id: Int)
    case comments(postId: Int)

    var baseURL: URL? {
        return ServiceFactory.resolve(AppConfigurationServiceProtocol.self)?.server
    }

    var path: String {
        switch self {
        case .posts: return "/posts"
        case .user, .users: return "/users"
        case .comments: return "/comments"
        }
    }

    var method: HTTPMethod {
        switch self {
        default: return HTTPMethod.get
        }
    }

    var params: [String: Any]? {
        switch self {
        case .user(let id):
            return ["id": id]
        case .comments(let postId):
            return ["postId": postId]
        default: return .none
        }
    }

    var encoder: ParameterEncoding {
        return URLEncoding.default
    }

    func asURLRequest() throws -> URLRequest {
        guard var URL = self.baseURL else {
            APPLogger.error { "Request to NOTHING. BaseURL is empty" }
            fatalError()
        }

        if self.path.count > 0 {
            URL = URL.appendingPathComponent(self.path)
        }

        var mutableURLRequest = URLRequest(url: URL)
        mutableURLRequest.httpMethod = self.method.rawValue

        return try self.encoder.encode(mutableURLRequest, with: self.params)
    }
}
