//
//  ExternalApi.swift
//  PostsViewer
//
//  Created by Genry on 3/23/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import MessageUI

class ExternalApi: NSObject {

    static let shared = ExternalApi()
    private override init() {
        super.init()
    }
}

// MARK: - Mail Delegate

extension ExternalApi: MFMailComposeViewControllerDelegate {

    func sendMail(for email: String) {
        if MFMailComposeViewController.canSendMail() {
            guard
                let navigationService = ServiceFactory.resolve(NavigationServiceProtocol.self),
                let topViewController = navigationService.topMostViewController
            else { return }

            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("<p>Hi</p><p/><p/><p>Best Regards</p>", isHTML: true)

            topViewController.present(mail, animated: true)
        } else {
            APPLogger.error { "Send email failed!" }
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: - Safary opening

extension ExternalApi {

    func openSafary(for urlString: String) {
        var components = URLComponents(string: urlString)
        components?.scheme = "http"

        guard let url = components?.url else { return }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
