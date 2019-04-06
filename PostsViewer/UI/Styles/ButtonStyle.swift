//
//  ButtonStyle.swift
//  PostsViewer
//
//  Created by Genry on 3/21/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

enum ButtonStyle {

    /// Style for navigation bar buttons.
    case smallButton
}

extension ButtonStyle {

    /// Define format and theme variations for the button styles here.
    func format() -> Format {
        switch self {
        case (.smallButton):
            return Format(titleFont: .smallest, normalTitleColor: .azure)
        }
    }

    /// The format to be applied to buttons.
    struct Format {

        var titleFont: UIFont

        var normalTitleColor: UIColor
        var highlightedTitleColor: UIColor?
        var selectedTitleColor: UIColor?
        var disabledTitleColor: UIColor?

        var normalBackgroundImage: UIImage?
        var highlightedBackgroundImage: UIImage?
        var selectedBackgroundImage: UIImage?
        var disabledBackgroundImage: UIImage?

        init(titleFont: UIFont,
             normalTitleColor: UIColor,
             normalBackgroundImage: UIImage? = nil,
             highlightedTitleColor: UIColor? = nil,
             highlightedBackgroundImage: UIImage? = nil,
             selectedTitleColor: UIColor? = nil,
             selectedBackgroundImage: UIImage? = nil,
             disabledTitleColor: UIColor? = nil,
             disabledBackgroundImage: UIImage? = nil) {

            self.titleFont = titleFont
            self.normalTitleColor = normalTitleColor
            self.highlightedTitleColor = highlightedTitleColor
            self.selectedTitleColor = selectedTitleColor
            self.disabledTitleColor = disabledTitleColor
            self.normalBackgroundImage = normalBackgroundImage
            self.highlightedBackgroundImage = highlightedBackgroundImage
            self.selectedBackgroundImage = selectedBackgroundImage
            self.disabledBackgroundImage = disabledBackgroundImage
        }
    }
}

/// Extension to apply `ButtonStyle` to a `UIButton`
extension UIButton {

    /// Applies a `ButtonStyle` to the target button.
    @discardableResult func apply(style: ButtonStyle) -> Self {

        let format = style.format()

        setTitleColor(format.normalTitleColor, for: .normal)
        setTitleColor(format.highlightedTitleColor, for: .highlighted)
        setTitleColor(format.selectedTitleColor, for: .selected)
        setTitleColor(format.disabledTitleColor, for: .disabled)

        setBackgroundImage(format.normalBackgroundImage, for: .normal)
        setBackgroundImage(format.highlightedBackgroundImage, for: .highlighted)
        setBackgroundImage(format.selectedBackgroundImage, for: .selected)
        setBackgroundImage(format.disabledBackgroundImage, for: .disabled)

        titleLabel?.font = format.titleFont

        return self
    }

    @discardableResult func setTitle(_ text: String?) -> Self {

        setTitle(text, for: .normal)
        return self
    }
}
