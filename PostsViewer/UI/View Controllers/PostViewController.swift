//
//  PostViewController.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit
import ReactiveSwift

/// Screen with post detailed info (user's info and comments)
class PostViewController: ReactiveViewController<PostViewModelProtocol> {

    /// General User info container which is showed when at least one value exist
    @IBOutlet weak var userStackView: UIStackView!
    /// User name container which is showed when it's not empty
    @IBOutlet weak var userNameStackView: UIStackView!
    /// User email container which is showed when it's not empty
    @IBOutlet weak var emailStackView: UIStackView!
    /// User company container which is showed when it's not empty
    @IBOutlet weak var companyStackView: UIStackView!
    /// User website container which is showed when it's not empty
    @IBOutlet weak var websiteStackView: UIStackView!

    /// User Name title
    @IBOutlet weak var userLabelTitle: UILabel!
    /// User Email title
    @IBOutlet weak var emailLabelTitle: UILabel!
    /// User Company title
    @IBOutlet weak var companyLabelTitle: UILabel!
    /// User Website title
    @IBOutlet weak var websiteLabelTitle: UILabel!
    /// User Name Label
    @IBOutlet weak var nameLabel: UILabel!
    /// User Email Label
    @IBOutlet weak var emailButton: UIButton!
    /// User Company Label
    @IBOutlet weak var companyLabel: UILabel!
    /// User Website Label
    @IBOutlet weak var websiteButton: UIButton!

    /// Post title label
    @IBOutlet weak var postTitleLabel: UILabel!
    /// Post body label
    @IBOutlet weak var postBodyLabel: UILabel!

    /// Comments stack container
    @IBOutlet weak var commentsStackView: UIStackView!
    /// Comments stack table list
    @IBOutlet weak var commentsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupViews()
        applyStyles()
    }
}

// MARK: - Private

private extension PostViewController {

    func applyStyles() {
        nameLabel.apply(style: .userNameText)
        emailButton.apply(style: .smallButton)
        companyLabel.apply(style: .companyNameText)
        websiteButton.apply(style: .smallButton)

        postTitleLabel.apply(style: .postTitle)
        postBodyLabel.apply(style: .postBodyText)
    }

    func setupViews() {
        navigationItem.title = "posts-detail.top-bar.title".localized
        userLabelTitle.text = "post-detail.user-area.name-label".localized
        emailLabelTitle.text = "post-detail.user-area.email-label".localized
        companyLabelTitle.text = "post-detail.user-area.company-label".localized
        websiteLabelTitle.text = "post-detail.user-area.website-label".localized
    }

    func setupBindings() {
        guard let viewModel = viewModel else { return }

        // User Info containers mapping
        userNameStackView.reactive.isHidden <~ viewModel.name.map { $0.isEmpty }
        emailStackView.reactive.isHidden    <~ viewModel.email.map { $0.isEmpty }
        companyStackView.reactive.isHidden  <~ viewModel.company.map { $0.isEmpty }
        websiteStackView.reactive.isHidden  <~ viewModel.website.map { $0.isEmpty }

        // Main container with user info
        userStackView.reactive.isHidden <~ SignalProducer.combineLatest(viewModel.name,
                                                                        viewModel.email,
                                                                        viewModel.company,
                                                                        viewModel.website)
            .map { name, email, company, website -> Bool in
                return name.isEmpty && email.isEmpty && company.isEmpty && website.isEmpty
        }

        // User properties
        nameLabel.reactive.text <~ viewModel.name
        emailButton.reactive.title <~ viewModel.email
        companyLabel.reactive.text <~ viewModel.company
        websiteButton.reactive.title <~ viewModel.website

        // Openning email to reply (works on real device only)
        emailButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [weak self] _ in
                guard let viewModel = self?.viewModel else { return }
                viewModel.sendEmail.apply().start()
        }

        // Openning safary browser
        websiteButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [weak self] _ in
                guard let viewModel = self?.viewModel else { return }
                viewModel.showWebsite.apply().start()
        }

        // Post info
        postTitleLabel.reactive.text <~ viewModel.title
        postBodyLabel.reactive.text <~ viewModel.body

        // Comments list 
        commentsTableView.reactive.isHidden <~ viewModel.commentsViewModel.map { $0.count == 0 }
        viewModel.commentsViewModel.producer
            .filter { $0.count > 0 }
            .startWithValues { [weak self]  _ in
                self?.commentsTableView.reloadData()
        }
    }
}

// MARK: - Table Delegte

extension PostViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.commentsViewModel.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let comment = viewModel?.commentsViewModel.value[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell
        else { return UITableViewCell() }

        cell.setupCell(with: comment)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
