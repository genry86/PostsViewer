//
//  PostCellViewModel.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import ReactiveSwift
import Result

/// Cell View for presenting post info
protocol PostCellViewModelProtocol {
    /// Post Id
    var id: Property<Int> { get }
    /// Post title
    var title: Property<String> { get }
    /// Post body
    var body: Property<String> { get }
    /// Post read/unread status
    var read: Property<Bool> { get }
}

final class PostCellViewModel: PostCellViewModelProtocol {

    private let mutableId = MutableProperty<Int>(0)
    lazy var id: Property<Int> = Property<Int>(capturing: mutableId)

    private let mutableTitle = MutableProperty<String>("")
    lazy var title: Property<String> = Property<String>(capturing: mutableTitle)

    private let mutableBody = MutableProperty<String>("")
    lazy var body: Property<String> = Property<String>(capturing: mutableBody)

    private let mutableRead = MutableProperty<Bool>(false)
    lazy var read: Property<Bool> = Property<Bool>(capturing: mutableRead)

    private let post = MutableProperty<Post?>(.none)

    init(for post: Post) {
        setupBindings()
        self.post.value = post
    }
}

// MARK: - Private

private extension PostCellViewModel {

    func setupBindings() {

        mutableId <~ post.producer
            .skipNil()
            .map { post in
                return post.id
        }

        mutableTitle <~ post.producer
            .skipNil()
            .map { post in
                return post.title
        }

        mutableBody <~ post.producer
            .skipNil()
            .map { post in
                return post.body
        }.skipNil()

        mutableRead <~ post.producer
            .skipNil()
            .map { post in
                return post.viewed
        }
    }
}
