//
//  PostListViewModel.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import ReactiveSwift
import Result

/// ViewModel for list with posts
protocol PostListViewModelProtocol {

    /// Internet connection status flag
    var networkAvailable: Property<Bool> { get }
    /// List of post cells view-models
    var postListViewModel: Property<[PostCellViewModelProtocol]> { get }

    /// Action to open detailed post screen
    var selectPost: Action<Int, (), NoError> { get }
    /// Action to fetch posts data from internet
    var fetchLifeData: Action<(), (), NoError> { get }
    /// Action to fetch data from local database
    var fetchCachedData: Action<(), (), NoError> { get }
}

final class PostListViewModel: PostListViewModelProtocol {

    private let mutableNetworkAvailable = MutableProperty<Bool>(true)
    lazy var networkAvailable: Property<Bool> = Property<Bool>(capturing: mutableNetworkAvailable)

    private let mutablePostListViewModel = MutableProperty<[PostCellViewModelProtocol]>([])
    lazy var postListViewModel = Property<[PostCellViewModelProtocol]>(capturing: mutablePostListViewModel)

    lazy var selectPost: Action<Int, (), NoError> = Action<Int, (), NoError>(execute: handleSelectedPost)
    lazy var fetchLifeData: Action<(), (), NoError> = Action<(), (), NoError>(execute: handleFetchLifeData)
    lazy var fetchCachedData: Action<(), (), NoError> = Action<(), (), NoError>(execute: handleFetchCachedData)

    // Services
    private let reachabilityService: ReachabilityServiceProtocol
    private let navigationService: NavigationServiceProtocol
    private let databaseService: DatabaseServiceProtocol

    // Managers
    private let postsManager: PostsManagerProtocol

    init(reachabilityService: ReachabilityServiceProtocol,
         postsManager: PostsManagerProtocol,
         navigationService: NavigationServiceProtocol,
         databaseService: DatabaseServiceProtocol) {

        self.reachabilityService = reachabilityService
        self.navigationService = navigationService
        self.postsManager = postsManager
        self.databaseService = databaseService

        setupBindings()
    }
}

// MARK: - Private

private extension PostListViewModel {

    func setupBindings() {
        mutableNetworkAvailable <~ reachabilityService.isNetworkAvailable
        fetchLifeData.apply().start()
    }

    func handleFetchLifeData() -> SignalProducer<(), NoError> {
        return SignalProducer { [weak self] observer, _ in
            guard let self = self else { return }

            self.postsManager.getPosts()
                .startWithResult { result in

                    switch result {
                    case .success(let posts):
                        self.mutablePostListViewModel.value = posts.map { PostCellViewModel(for: $0) }

                    case .failure(let error):
                        APPLogger.info { "Fetch posts failed: \(error)" }
                    }
            }
            return observer.sendCompleted()
        }
    }

    func handleFetchCachedData() -> SignalProducer<(), NoError> {
        return SignalProducer { [weak self] observer, _ in
            guard
                let self = self,
                let posts: [Post] = self.databaseService.getObjects()
            else { return }

            self.mutablePostListViewModel.value = posts.map { PostCellViewModel(for: $0) }
            return observer.sendCompleted()
        }
    }

    func handleSelectedPost(_ postId: Int) -> SignalProducer<(), NoError> {
        return SignalProducer { [weak self] observer, _ in
            guard
                let self = self,
                let url = VCRouter.postDetail.url(withParameters: [VCRouter.ParameterKey.postId: String(postId)])
            else { return observer.sendInterrupted() }

            self.navigationService.navigate(to: url)

            return observer.sendCompleted()
        }
    }
}
