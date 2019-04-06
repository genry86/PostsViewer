//
//  Int+Extension.swift
//  PostsViewer
//
//  Created by Genry on 3/21/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

// MARK: - Degrees to radians

extension Int {

    /// Convert degrees to radians. Used in layer animation
    var radians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
