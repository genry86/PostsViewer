//
//  ViewModelsAssembly.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import SwinjectAutoregistration

final class ViewModelsAssembly {

    static func register() {
        ServiceFactory.container.autoregister(SplashViewModelProtocol.self, initializer: SplashViewModel.init)
            .inObjectScope(.transient)
        ServiceFactory.container.autoregister(PostCellViewModelProtocol.self, initializer: PostCellViewModel.init)
            .inObjectScope(.transient)
        ServiceFactory.container.autoregister(CommentCellViewModelProtocol.self, initializer: CommentCellViewModel.init)
            .inObjectScope(.transient)
        ServiceFactory.container.autoregister(PostListViewModelProtocol.self, initializer: PostListViewModel.init)
            .inObjectScope(.transient)
        ServiceFactory.container.autoregister(PostViewModelProtocol.self, initializer: PostViewModel.init)
            .inObjectScope(.transient)
        ServiceFactory.container.autoregister(NotificationAlertViewModelProtocol.self, initializer: NotificationAlertViewModel.init)
            .inObjectScope(.transient)
    }
}
