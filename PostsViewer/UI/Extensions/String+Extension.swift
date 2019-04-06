//
//  String+Extension.swift
//  PostsViewer
//
//  Created by Genry on 3/27/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

extension String {

    /// Helper method to localize string
    var localized: String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: Bundle.main,
            value: "",
            comment: ""
        )
    }
}
