//
//  ReactiveViewController.swift
//  PostsViewer
//
//  Created by Genry on 3/26/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit
import ReactiveCocoa

/// Base class with generic view model for all UI controllers
class ReactiveViewController<T>: UIViewController {

    /// Connected view model to subclassed controller
    let viewModel: T? = {
        return ServiceFactory.resolve(T.self)
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
