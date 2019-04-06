//
//  CommentCell.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit
import ReactiveSwift

/// Cell Table View used to present comment of users under post. On the detailed post screen
final class CommentCell: UITableViewCell {

    /// Comment title
    @IBOutlet weak var commentLabel: UILabel!
    /// Email of user who left comment
    @IBOutlet weak var emailButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyles()
    }
}

// MARK: - public

extension CommentCell {

    func setupCell(with viewModel: CommentCellViewModelProtocol) {

        commentLabel.reactive.text <~ viewModel.comment
        emailButton.reactive.title <~ viewModel.email

        emailButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                viewModel.sendEmail.apply().start()
        }
    }
}

// MARK: - Private

private extension CommentCell {

    func applyStyles() {
        commentLabel.apply(style: .commentText)
        emailButton.apply(style: .smallButton)
    }
}
