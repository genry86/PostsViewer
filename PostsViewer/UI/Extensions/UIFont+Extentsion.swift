//
//  UIFont+Extentsion.swift
//  PostsViewer
//
//  Created by Genry on 3/21/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

/// Extension to quickly define fonts.
extension UIFont {

    static let h1   =   UIFont.systemFont(ofSize: 66, weight: UIFont.Weight.bold)
    static let h2   =   UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
    static let h3   =   UIFont.systemFont(ofSize: 16)

    static let regular      =    UIFont.systemFont(ofSize: 15)
    static let small        =    UIFont.systemFont(ofSize: 14)
    static let smallest     =    UIFont.systemFont(ofSize: 12)
    static let smallestBold =    UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
}
