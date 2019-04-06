//
//  PostsTableViewController.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//
import UIKit
import ReactiveSwift

/// Screen with list of posts
class PostListViewController: ReactiveViewController<PostListViewModelProtocol> {

    /// Status message label. Showed when no data.
    @IBOutlet weak var statusMessageLabel: UILabel!
    /// Table list with posts' cells
    @IBOutlet weak var postListTableView: UITableView!
    /// Refresh control to initiate reload of data json
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupViews()
        applyStyles()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let viewModel = viewModel else { return }
        viewModel.fetchCachedData.apply().start()
    }
}

// MARK: - Private

private extension PostListViewController {

    func setupViews() {
        navigationItem.title = "posts-list.top-bar.title".localized
        statusMessageLabel.text = "posts-list.status-message.no-data".localized

        if #available(iOS 10.0, *) {
            postListTableView.refreshControl = refreshControl
        } else {
            postListTableView.addSubview(refreshControl)
        }

        refreshControl.reactive
            .controlEvents(.valueChanged)
            .observeValues { [weak self] _ in
                guard let viewModel = self?.viewModel else { return }
                viewModel.fetchLifeData.apply().start()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
                    self?.refreshControl.endRefreshing()
                }
        }
    }

    func applyStyles() {
        statusMessageLabel.apply(style: .statusText)
    }

    func setupBindings() {
        guard let viewModel = viewModel else { return }

        statusMessageLabel.reactive.isHidden <~ viewModel.postListViewModel.map { $0.count > 0 }

        viewModel.postListViewModel.producer
            .observe(on: QueueScheduler.main)
            .filter { $0.count > 0 }
            .startWithValues { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.postListTableView.reloadData()
        }
    }
}

// MARK: - Table Delegte

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.postListViewModel.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let post = viewModel?.postListViewModel.value[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell
        else { return UITableViewCell() }

        cell.setupCell(with: post)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }

        let post = viewModel.postListViewModel.value[indexPath.row]
        viewModel.selectPost.apply(post.id.value).start()
    }
}
