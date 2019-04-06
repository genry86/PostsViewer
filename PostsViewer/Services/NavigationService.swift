//
//  NavigationService.swift
//  PostsViewer
//
//  Created by Genry on 3/20/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import JLRoutes
import ReactiveSwift
import Result
import ObjectMapper

/// Navigation Router
protocol NavigationRouterProtocol {
    var pattern: String { get }
    var url: URL? { get }
    func url(withParameters parameters: [VCRouter.ParameterKey: CustomStringConvertible]) -> URL?
}

/// Enum describing the possible navigation routes
enum VCRouter: NavigationRouterProtocol {

    case postList
    case postDetail
    case notificationAlert
    //TODO: Add any other routes...

    /// Enum describing the possible keys that can be added to a URL
    enum ParameterKey: String {
        case postId
        case userId
    }

    var appScheme: String {
        return "demo"
    }

    /// The pattern that should be matched for a given route
    var pattern: String {
        switch self {
        case .postList: return "postList"
        case .postDetail: return "postDetail"
        case .notificationAlert: return "notificationAlert"
            // MARK: Add any other routes...
        }
    }

    /// The url describing the route
    var url: URL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = appScheme
        urlComponents.path = pattern
        return urlComponents.url
    }

    /// The url describing the route using parameters (ex. navigationService.navigate(fromVC: nil, usingUrl: VCRouter.chatDetail.url(withParameters: [VCRouter.ParameterKey.chatDetail: "123"])))
    ///
    /// - Parameter parameters: The parameters that are added to the route
    /// - Returns: The url describing the route
    func url(withParameters parameters: [VCRouter.ParameterKey: CustomStringConvertible]) -> URL? {
        guard let url = url else {
            return nil
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = []
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key.rawValue, value: String(describing: value))
            urlComponents?.queryItems?.append(queryItem)
        }
        return urlComponents?.url
    }
}

/// Service protocol definition
protocol NavigationServiceProtocol {

    /// Top Controller on screen
    var topMostViewController: UIViewController? { get }

    /// Initial UIViewController presented at start
    var initialController: UIViewController? { get }

    /// Navigate to another VC using a given url
    ///
    /// - Parameters:
    ///   - url: The url to follow
    /// - Returns: The result of the possible navigation; 'true' -> the navigation is possible, 'false' -> if not
    @discardableResult func navigate(to url: URL?) -> Bool
}

final class NavigationService: NavigationServiceProtocol {

    var topMostViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.topMostViewController
    }

    var initialController: UIViewController? {
        return ServiceFactory.initiateViewController(
            storyboardName: "Main",
            type: SplashViewController.self
        )
    }

    required init() {
        addPostListRoute()
        addPostDetailRoute()
        addNotificationAlertRoute()
    }

    @discardableResult func navigate(to url: URL?) -> Bool {
        guard let url = url else { return false }
        return JLRoutes.routeURL(url)
    }
}

private extension NavigationService {

    func addPostListRoute() {
        JLRoutes.global().addRoute(VCRouter.postList.pattern) { [weak self] _ in
            guard let self = self else { return false }

            let viewController = ServiceFactory.initiateViewController(
                storyboardName: "Main",
                type: PostListViewController.self
            )
            let controller = UINavigationController.encapsulate(viewController: viewController)
            self.present(viewController: controller)
            return true
        }
    }

    func addPostDetailRoute() {
        JLRoutes.global().addRoute(VCRouter.postDetail.pattern) { [weak self] parameters in
            guard
                let self = self,
                let postIdParam = parameters[VCRouter.ParameterKey.postId.rawValue] as? String,
                let postId = Int(postIdParam)
            else { return false }

            let viewController = ServiceFactory.initiateViewController(
                storyboardName: "Main",
                type: PostViewController.self
            )

            if let _ = parameters[VCRouter.ParameterKey.postId.rawValue] as? String {
                viewController.viewModel?.postId.value = postId
            }

            self.present(viewController: viewController)
            return true
        }
    }

    func addNotificationAlertRoute() {
        JLRoutes.global().addRoute(VCRouter.notificationAlert.pattern) { _ in
            guard
                let viewModel = ServiceFactory.resolve(NotificationAlertViewModelProtocol.self),
                let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
                let alertView = NotificationAlertView.fromNib()
            else { return false }

            rootViewController.view.addSubview(alertView)
            alertView.setupViewModel(viewModel: viewModel)
            alertView.slideDown()

            return true
        }
    }
}

private extension NavigationService {

    func present(viewController: UIViewController,
                 mode presentationMode: UIViewController.PresentationMode = .push) {

        switch presentationMode {
        case .modal:
            topMostViewController?.present(viewController, animated: true, completion: .none)
        case .push:
            topMostViewController?.show(viewController, sender: self)
        }
    }

}
