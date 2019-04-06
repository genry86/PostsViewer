//
//  APPLogger.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import SwiftyBeaver
import ReactiveSwift
import Result

class APPLogger {

    static let shared = APPLogger()
    var (signal, observer) = Signal<(level: Level, text: String), NoError>.pipe()

    fileprivate let logger = SwiftyBeaver.self
}

// MARK: - Public

extension APPLogger {

    enum Level: String, Comparable {
        case verbose = "Verbose"
        case debug = "Debug"
        case info = "Info"
        case warning = "Warning"
        case error = "Error"
        case none = "None"

        var value: Int {
            switch self {
            case .verbose: return 1
            case .debug: return 2
            case .info: return 3
            case .warning: return 4
            case .error: return 5
            case .none: return 10
            }
        }

        static func < (lhs: Level, rhs: Level) -> Bool {
            return lhs.value < rhs.value
        }

        static func <= (lhs: Level, rhs: Level) -> Bool {
            return lhs.value <= rhs.value
        }

        static func >= (lhs: Level, rhs: Level) -> Bool {
            return lhs.value >= rhs.value
        }

        static func > (lhs: Level, rhs: Level) -> Bool {
            return lhs.value > rhs.value
        }
    }

    static func verbose(msg block: () -> String) {
        self.shared.verbose(msg: block)
    }

    static func debug(msg block: () -> String) {
        self.shared.debug(msg: block)
    }

    static func info(msg block: () -> String) {
        self.shared.info(msg: block)
    }

    static func warning(msg block: () -> String) {
        self.shared.warning(msg: block)
    }

    static func error(msg block: () -> String) {
        self.shared.error(msg: block)
    }

    func start() {

        let console = ConsoleDestination()
        console.format = "$Ddd/MM/yyyy HH:mm:ss$d $C$L$c $F:$l - $M"
        console.levelString.verbose = "👻 VERBOSE"
        console.levelString.debug = "😑 DEBUG"
        console.levelString.info = "📱 INFO"
        console.levelString.warning = "👮🏻 WARNING"
        console.levelString.error = "💣 ERROR"

        self.logger.addDestination(console)
    }
}

// MARK: - Private

private extension APPLogger {

    func verbose(msg block: () -> String) {
        self.observer.send(value: (level: .verbose, text: block()))
        self.logger.verbose(block())
    }

    func debug(msg block: () -> String) {
        self.observer.send(value: (level: .debug, text: block()))
        self.logger.debug(block())
    }

    func info(msg block: () -> String) {
        self.observer.send(value: (level: .info, text: block()))
        self.logger.info(block())
    }

    func warning(msg block: () -> String) {
        self.observer.send(value: (level: .warning, text: block()))
        self.logger.warning(block())
    }

    func error(msg block: () -> String) {
        self.observer.send(value: (level: .error, text: block()))
        self.logger.error(block())
    }
}
