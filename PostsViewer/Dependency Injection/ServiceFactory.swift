//
//  ServiceFactory.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Swinject

enum ServiceFactory {

    static let container = Container()

    static func initiateViewController<T: UIViewController>(storyboardName name: String, type: T.Type) -> T {
        return initiateViewController(from: name, identifier: String(describing: type))
    }

    static func initiateViewController<T: UIViewController>(from storyboard: String, identifier: String) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier) as? T ?? T()
    }

    static func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }

    static func registerAll() {
        ServicesAssembly.register()
        ManagersAssembly.register()
        ViewModelsAssembly.register()
    }
}
