//
//  ManagersAssembly.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import SwinjectAutoregistration

final class ManagersAssembly {

    static func register() {
        ServiceFactory.container.autoregister(PostsManagerProtocol.self, initializer: PostsManager.init)
            .inObjectScope(.container)
        ServiceFactory.container.autoregister(UsersManagerProtocol.self, initializer: UsersManager.init)
            .inObjectScope(.container)
        ServiceFactory.container.autoregister(CommentsManagerProtocol.self, initializer: CommentsManager.init)
            .inObjectScope(.container)
    }
}
