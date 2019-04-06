//
//  UIViewController+Extension.swift
//  PostsViewer
//
//  Created by Genry on 3/20/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

extension UIViewController {

    /// Presentation mode 'push' or 'modal'
    enum PresentationMode: String, CustomStringConvertible {
        case push
        case modal
        var description: String {
            return rawValue
        }
    }

    /// Top Presented UIViewController
    var topMostViewController: UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topMostViewController
        }

        switch self {
        case let navigationController as UINavigationController:
            return navigationController.viewControllers.last?.topMostViewController ?? self
        case let tabBarController as UITabBarController:
            return tabBarController.selectedViewController?.topMostViewController ?? self
        default:
            return self
        }
    }
}
