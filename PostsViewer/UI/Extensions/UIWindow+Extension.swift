//
//  UIWindow+Extension.swift
//  PostsViewer
//
//  Created by Genry on 3/20/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

extension UIWindow {

    /// Top Root UIViewController used to present other elements on it
    var topMostViewController: UIViewController? {
        return self.rootViewController?.topMostViewController
    }
}
