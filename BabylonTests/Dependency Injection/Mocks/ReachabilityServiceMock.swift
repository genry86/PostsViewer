//
//  ReachabilityServiceMock.swift
//  PostsViewerTests
//
//  Created by Genry on 3/24/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import Foundation
import Reachability
import ReactiveSwift
import Result
import UIKit

@testable import PostsViewer

final class ReachabilityServiceMock: ReachabilityServiceProtocol {

    let mutableIsNetworkAvailable = MutableProperty<Bool>(true)
    lazy var isNetworkAvailable: Property<Bool> = Property<Bool>(capturing: mutableIsNetworkAvailable)

    func start() {}
}
