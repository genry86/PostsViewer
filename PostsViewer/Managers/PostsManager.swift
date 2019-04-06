//
//  PostsManager.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Alamofire
import ReactiveSwift
import AlamofireObjectMapper
import RealmSwift

/// Manager to fetch posts
protocol PostsManagerProtocol {
    func getPosts() -> SignalProducer<[Post], RequestError>
}

final class PostsManager: PostsManagerProtocol {

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

    func getPosts() -> SignalProducer<[Post], RequestError> {

        return SignalProducer <[Post], RequestError> { [weak self] sink, disposable in
            guard let self = self else { return sink.send(error: .selfDeallocated) }

            self.reachabilityService.isNetworkAvailable
                .producer
                .observe(on: QueueScheduler.init())
                .startWithValues { isNetworkAvailable in
                    if isNetworkAvailable || Platform.isSimulator {
                        let route = Route.posts
                        let request = self.apiService.dataRequest(for: route)
                            .responseArray { (response: DataResponse<[Post]>) in
                                switch response.result {
                                case .success(let posts):

                                    self.databaseService.saveObjects(objects: posts)
                                    sink.send(value: posts)
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
                            let posts: [Post] = self.databaseService.getObjects()
                        else { return }

                        sink.send(value: posts)
                        sink.sendCompleted()
                    }
            }
        }
    }
}
