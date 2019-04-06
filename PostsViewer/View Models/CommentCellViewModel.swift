//
//  CommentCellViewModel.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import ReactiveSwift
import Result

/// Cell for presenting comment info
protocol CommentCellViewModelProtocol {
    /// Comment content
    var comment: Property<String> { get }
    /// Email of user who left comment
    var email: Property<String> { get }

    /// Action to reply on email
    var sendEmail: Action<(), (), NoError> { get }
}

final class CommentCellViewModel: CommentCellViewModelProtocol {

    private let mutableComment = MutableProperty<String>("")
    lazy var comment: Property<String> = Property<String>(capturing: mutableComment)

    private let mutableEmail = MutableProperty<String>("")
    lazy var email: Property<String> = Property<String>(capturing: mutableEmail)

    lazy var sendEmail: Action<(), (), NoError> = Action<(), (), NoError>(execute: handleSendEmail)

    private let postComment = MutableProperty<Comment?>(.none)

    init(for postComment: Comment) {
        setupBindings()
        self.postComment.value = postComment
    }
}

// MARK: - Private

private extension CommentCellViewModel {

    func setupBindings() {

        mutableComment <~ postComment.producer
            .skipNil()
            .map { postComment in
                return postComment.body
        }.skipNil()

        mutableEmail <~ postComment.producer
            .skipNil()
            .map { postComment in
                return postComment.email
        }.skipNil()
    }

    func handleSendEmail() -> SignalProducer<(), NoError> {
        return SignalProducer { [weak self] observer, _ in
            guard let email = self?.email.value else { return }

            ExternalApi.shared.sendMail(for: email)
            observer.sendCompleted()
        }
    }
}
