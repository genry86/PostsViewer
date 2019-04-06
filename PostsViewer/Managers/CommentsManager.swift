//
//  CommentsManager.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Alamofire
import ReactiveSwift

/// Manager to fetch comments
protocol CommentsManagerProtocol {
    func getComments(postId: Int) -> SignalProducer<[Comment], RequestError>
}

final class CommentsManager: CommentsManagerProtocol {

    private let apiService: APIServiceProtocol
    private let reachabilityService: ReachabilityServiceProtocol
    private let databaseService: DatabaseServiceProtocol

    init(apiService: APIServiceProtocol,
         reachabilityService: ReachabilityServiceProtocol,
         databaseService: DatabaseServiceProtocol) {
        self.reachabilityService = reachabilityService
        self.apiService = apiService
        self.databaseService = databaseService
    }

    func getComments(postId: Int) -> SignalProducer<[Comment], RequestError> {

        return SignalProducer <[Comment], RequestError> { [weak self] sink, disposable in
            guard let self = self else { return sink.send(error: .selfDeallocated) }

            self.reachabilityService.isNetworkAvailable
                .producer
                .observe(on: QueueScheduler.init())
                .startWithValues { isNetworkAvailable in
                    if isNetworkAvailable {
                        let route = Route.comments(postId: postId)
                        let request = self.apiService.dataRequest(for: route)
                            .responseArray { (response: DataResponse<[Comment]>) in
                                switch response.result {
                                case .success(let comments):

                                    self.databaseService.saveObjects(objects: comments)
                                    sink.send(value: comments)
                                    sink.sendCompleted()

                                case .failure(let error):
                                    sink.send(error: .httpError(error))
                                }
                        }

                        disposable.observeEnded {
                            request.cancel()
                        }
                    } else {
                        guard
                            let comments: [Comment] = self.databaseService
                                .getObjects(filter: NSPredicate(format: "postId == %d", postId))
                        else { return }

                        sink.send(value: comments)
                        sink.sendCompleted()
                    }
            }
        }
    }
}
