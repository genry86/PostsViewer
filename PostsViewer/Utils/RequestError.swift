//
//  RequestError.swift
//  PostsViewer
//
//  Created by Genry on 3/20/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import SwiftyJSON

/// General all purpose error to be used on `SignalProducers`.
enum RequestError: Error, CustomStringConvertible {

    // MARK: - HTTP Errors

    /// Unrecognized API Error (Http)
    case httpError(Error)

    /// 401 Response (Http)
    case unauthorized

    /// No Data
    case noData

    /// API Error - (Http; 400 <= statusCode <= 499)
    case apiError(apiError: Error, errorJSON: JSON)

    // MARK: - App Errors

    /// Couldn't find object on the DB
    case notFound

    /// Missing Id
    case missingId

    /// Couln't parse the HTTP Response data.
    case parseError

    // Self was deallocated
    case selfDeallocated
}

// MARK: -

extension RequestError {

    var description: String {
        switch self {
        case .unauthorized:
            return "Unauthorized"
        case .apiError(_, let errorJSON):
            return "API Error: \(errorJSON.description)"
        case .httpError(let httpError):
            return "HTTP Error: \(httpError.localizedDescription)"
        default:
            return "Unknown Request Error"
        }
    }
}
