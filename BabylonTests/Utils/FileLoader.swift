//
//  FileLoader.swift
//  PostsViewerTests
//
//  Created by Genry on 3/25/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class FileLoader {

    static func loadJSON(name: String) -> JSON? {
        let bundle = Bundle(for: FileLoader.self)
        if let path = bundle.path(forResource: name, ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return try JSON(data: jsonData)
            } catch {
                return nil
            }
        }
        return nil
    }
}
