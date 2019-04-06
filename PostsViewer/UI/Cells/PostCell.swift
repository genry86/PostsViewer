//
//  PostCell.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit
import ReactiveSwift

/// Cell Table view used on Post-List screen
final class PostCell: UITableViewCell {

    /// icon image which shows post-read status if it was viewed on detailed screen
    @IBOutlet weak var readStatusImageView: UIImageView!
    /// post title
    @IBOutlet weak var postTitleLabel: UILabel!
    /// post body content
    @IBOutlet weak var postBodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyles()
    }
}

// MARK: - public

extension PostCell {

    func setupCell(with viewModel: PostCellViewModelProtocol) {
        postTitleLabel.reactive.text <~ viewModel.title
        postBodyLabel.reactive.text <~ viewModel.body

        readStatusImageView.reactive.image <~ viewModel.read.map { isRead in
            return isRead ? #imageLiteral(resourceName: "post_read") : #imageLiteral(resourceName: "post_unread")
        }
    }
}

// MARK: - Private

private extension PostCell {

    func applyStyles() {
        postTitleLabel.apply(style: .postListTitle)
        postBodyLabel.apply(style: .postListBodyText)
    }
}
