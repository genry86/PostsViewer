//
//  UIView+Extension.swift
//  PostsViewer
//
//  Created by Genry on 3/20/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

extension UIView {

    /// Initializing UIView using short method 'fromNib'
    public class func fromNib() -> Self? {
        func fromNibHelper<T>() -> T? where T: UIView {
            let bundle = Bundle(for: T.self)
            return bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as? T
        }
        return fromNibHelper()
    }
}
