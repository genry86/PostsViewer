//
//  TestFileHelper.swift
//  PostsViewerTests
//
//  Created by Genry on 3/24/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Foundation
import UIKit

class TestFileHelper {

    class func jsonFromFile(filename: String) -> [String: Any] {
        let data = dataFromFile(filename: filename)
        return try! JSONSerialization.jsonObject(with: data as Data, options: []) as! [String: Any]
    }

    class func dataFromFile(filename: String) -> NSData {
        let path = Bundle(for: TestFileHelper.self).path(forResource: filename, ofType: "json")!
        return NSData(contentsOfFile: path)!
    }
}
