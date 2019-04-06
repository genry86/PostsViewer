//
//  Platform.swift
//  PostsViewer
//
//  Created by Genry on 3/28/19.
//  Copyright © 2019 Genry. All rights reserved.
//

struct Platform {

    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}
