//
//  UsersManager.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Alamofire
import ReactiveSwift

/// Manager to fetch user info
protocol UsersManagerProtocol {
    func getUser(id: Int) -> SignalProducer<User?, RequestError>
}

final class UsersManager: UsersManagerProtocol {

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

    func getUser(id: Int) -> SignalProducer<User?, RequestError> {

        return SignalProducer <User?, RequestError> { [weak self] sink, disposable in
            guard let self = self else { return sink.send(error: .selfDeallocated) }

            self.reachabilityService.isNetworkAvailable
                .producer
                .startWithValues { isNetworkAvailable in
                    if isNetworkAvailable {
                        let route = Route.user(id: id)
                        let request = self.apiService.dataRequest(for: route)
                            .responseArray(queue: DispatchQueue.main) { (response: DataResponse<[User]>) in
                                switch response.result {
                                case .success(let objects):
                                    guard
                                        let user = objects.first
                                    else { return }

                                    try? self.databaseService.db?.write {
                                        self.databaseService.saveObject(object: user)
                                    }
                                    sink.send(value: user)
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
                            let user: User = self.databaseService.getObject(id: id)
                        else { return }
                        sink.send(value: user)
                        sink.sendCompleted()
                    }
            }
        }
    }
}
