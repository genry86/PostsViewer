//
//  APIService.swift
//  PostsViewer
//
//  Created by Genry on 3/20/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Alamofire
import ReactiveSwift

/// A service that performs URL requests to API endpoints.
protocol APIServiceProtocol {

    /// Creates a `DataRequest` to retrieve the contents of an API endpoint represented by a `URLRequestConvertible` type.
    ///
    /// - Parameter route: The type containing necessary informations to construct the `URL` request.
    /// - Returns: The `DataRequest` ready to be executed by the caller.
    func dataRequest(for route: Route) -> DataRequest
}

final class APIService: APIServiceProtocol {

    lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()

    func dataRequest(for route: Route) -> DataRequest {
        return sessionManager.request(route)
    }
}
