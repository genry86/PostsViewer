//
//  LabelStyle.swift
//  PostsViewer
//
//  Created by Genry on 3/21/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

/// Extension to apply `Style` to a `UILabel`
extension UILabel {

    func apply(style: LabelStyle) {
        let format = style.format()
        font = format.font
        textColor = format.color
    }
}

/// Text style definitions that can be applied to Labels
enum LabelStyle {

    case appTitle

    case statusText

    case postListTitle

    case postListBodyText

    case postTitle

    case postBodyText

    case userNameText

    case userText

    case companyNameText

    case commentText
}

extension LabelStyle {

    /// Define format and theme variations for the text styles here.
    func format() -> Format {
        switch self {
        case (.appTitle):
            return Format(font: .h1, color: .regular)

        case (.statusText):
            return Format(font: .small, color: .white, background: .red)

        case (.postListTitle):
            return Format(font: .h2, color: .regular)

        case (.postListBodyText):
            return Format(font: .small, color: .lightGray)

        case (.postTitle):
            return Format(font: .h2, color: .regular)

        case (.postBodyText):
            return Format(font: .regular, color: .regular)

        case (.userNameText):
            return Format(font: .smallestBold, color: .regular)

        case (.userText):
            return Format(font: .smallest, color: .regular)

        case (.companyNameText):
            return Format(font: .smallest, color: .lightGray)

        case (.commentText):
            return Format(font: .smallest, color: .regular)

        }
    }

    /// The format representation to be applied to Labels. That is the font and color and highlighted color.
    struct Format {
        var font: UIFont
        var color: UIColor
        var background: UIColor

        init(font: UIFont,
             color: UIColor,
             background: UIColor = .clear) {
            self.font = font
            self.color = color
            self.background = background
        }
    }
}
