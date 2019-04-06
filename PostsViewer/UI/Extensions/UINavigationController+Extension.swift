//
//  UINavigationController+Extension.swift
//  PostsViewer
//
//  Created by Genry on 3/20/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

extension UINavigationController {

    /// Incapsulating UIViewController into UINavigationController
    static func encapsulate(viewController root: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }
}
