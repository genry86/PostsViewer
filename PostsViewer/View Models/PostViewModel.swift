//
//  PostViewModel.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import ReactiveSwift
import Result
import MessageUI

/// ViewModel with detailed post screen
protocol PostViewModelProtocol {

    /// Post title
    var title: Property<String> { get }
    /// Post Body
    var body: Property<String> { get }

    /// User name
    var name: Property<String> { get }
    /// User email
    var email: Property<String> { get }
    /// User company
    var company: Property<String> { get }
    /// User website
    var website: Property<String> { get }

    /// post id used to fetch all other data
    var postId: MutableProperty<Int?> { get }

    /// List of comments' ViewModels
    var commentsViewModel: Property<[CommentCellViewModelProtocol]> { get }

    /// Action to send email (works on real device only)
    var sendEmail: Action<(), (), NoError> { get }
    /// Action to open website
    var showWebsite: Action<(), (), NoError> { get }
}

final class PostViewModel: PostViewModelProtocol {

    // Post
    private let mutableTitle = MutableProperty<String>("")
    lazy var title: Property<String> = Property<String>(capturing: mutableTitle)

    private let mutableBody = MutableProperty<String>("")
    lazy var body: Property<String> = Property<String>(capturing: mutableBody)

    // User
    private let mutableName = MutableProperty<String>("")
    lazy var name: Property<String> = Property<String>(capturing: mutableName)

    private let mutableEmail = MutableProperty<String>("")
    lazy var email: Property<String> = Property<String>(capturing: mutableEmail)

    private let mutableCompany = MutableProperty<String>("")
    lazy var company: Property<String> = Property<String>(capturing: mutableCompany)

    private let mutableWebsite = MutableProperty<String>("")
    lazy var website: Property<String> = Property<String>(capturing: mutableWebsite)

    // Comments
    private let mutableCommentsViewModel = MutableProperty<[CommentCellViewModelProtocol]>([])
    lazy var commentsViewModel = Property<[CommentCellViewModelProtocol]>(capturing: mutableCommentsViewModel)

    lazy var sendEmail: Action<(), (), NoError> = Action<(), (), NoError>(execute: handleSendEmail)
    lazy var showWebsite: Action<(), (), NoError> = Action<(), (), NoError>(execute: handleShowWebsite)

    // Services
    private let navigationService: NavigationServiceProtocol
    private let databaseService: DatabaseServiceProtocol
    private let reachabilityService: ReachabilityServiceProtocol

    var postId = MutableProperty<Int?>(.none)
    private let post = MutableProperty<Post?>(.none)
    private let user = MutableProperty<User?>(.none)

    // Managers
    private let usersManager: UsersManagerProtocol
    private let commentsManager: CommentsManagerProtocol

    init(navigationService: NavigationServiceProtocol,
         databaseService: DatabaseServiceProtocol,
         usersManager: UsersManagerProtocol,
         commentsManager: CommentsManagerProtocol,
         reachabilityService: ReachabilityServiceProtocol) {

        self.navigationService = navigationService
        self.databaseService = databaseService
        self.reachabilityService = reachabilityService
        self.usersManager = usersManager
        self.commentsManager = commentsManager

        setupBindings()
    }
}

// MARK: - Private

private extension PostViewModel {

    func setupBindings() {

        postId.signal.skipNil().observeValues { [weak self] postId in
            guard
                let self = self,
                let post: Post = self.databaseService.getObject(id: postId)
            else { return }
            let userId = post.userId

            // post
            try? self.databaseService.db?.write {
                post.viewed = true
                self.databaseService.saveObject(object: post)
            }
            self.post.value = post

            // user
            self.usersManager.getUser(id: userId)
                .observe(on: QueueScheduler.main)
                .startWithResult { result in

                switch result {
                case .success(let user):
                    self.user.value = user

                case .failure(let error):
                    APPLogger.info { "Fetch user failed: \(error)" }
                }
            }

            // comments
            self.commentsManager.getComments(postId: postId)
                .startWithResult { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .success(let comments):
                        self.mutableCommentsViewModel.value = comments.map { CommentCellViewModel(for: $0) }

                    case .failure(let error):
                        APPLogger.info { "Fetch comments failed: \(error)" }
                    }
            }
        }

        // post Info
        mutableTitle <~ post.signal.skipNil().map { $0.title }
        mutableBody <~ post.signal.skipNil().map { $0.body }.skipNil()

        // user Info
        mutableName <~ user.signal.skipNil().map { $0.username }
        mutableEmail <~ user.signal.skipNil().map { $0.email }.skipNil()
        mutableCompany <~ user.signal.skipNil().map { $0.company }.skipNil()
        mutableWebsite <~ user.signal.skipNil().map { $0.website}.skipNil()

        // re-fetch data if network appear
        Signal.combineLatest(postId.signal.skipNil().skipRepeats(),
                             reachabilityService.isNetworkAvailable.signal.skipRepeats(),
                             user.signal,
                             commentsViewModel.signal)
            .filter { _, isNetworkAvailable, user, comments in
                return isNetworkAvailable && (user == .none || comments.count == 0)
            }
            .observeValues { [weak self] postId, _, _, _ in
                self?.postId.value = postId
        }
    }

    func handleSendEmail() -> SignalProducer<(), NoError> {
        return SignalProducer { [weak self] observer, _ in
            guard
                let user = self?.user.value,
                let email = user.email
            else { return }

            ExternalApi.shared.sendMail(for: email)
            observer.sendCompleted()
        }
    }

    func handleShowWebsite() -> SignalProducer<(), NoError> {
        return SignalProducer { [weak self] observer, _ in
            guard
                let user = self?.user.value,
                let website = user.website
            else { return }

            ExternalApi.shared.openSafary(for: website)
            observer.sendCompleted()
        }
    }
}
