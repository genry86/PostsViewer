//
//  UITableViewCell+Extension.swift
//  PostsViewer
//
//  Created by Genry on 3/22/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

extension UITableViewCell {

    /// Identifier String which identical with class name
    class var identifier: String {
        return String(describing: self)
    }
}
