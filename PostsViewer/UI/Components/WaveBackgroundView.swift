//
//  WaveBackgroundView.swift
//  PostsViewer
//
//  Created by Genry on 3/8/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

/**
 Background with non-standard wave shape at the bottom.
 Initialize it with Indent from top of view and with fill color.
 Use `func layoutSubviews()` of view to setup it, due to proper frame value.

 - Example
 ````
 // From a view:
 let shapeBackgroundView = WaveBackgroundView(frame: backgroundShapeView.frame,
 topIndend: 150,
 backgroundShapeColor: UIColor.bermuda100)
 backgroundShapeView.addSubview(shapeBackgroundView)
 ````

 - Parameter frame: full frame of your view
 - Parameter topIndent: indent from top to bottom of filled shape
 - Parameter backgroundShapeColor: color of shape background
 */

final class WaveBackgroundView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        let topIndent = frame.maxY * 0.4
        let backgroundShapeColor = UIColor.azure

        let verticalIntendWave = CGFloat(70)
        let centerIntendWave = CGFloat(20)

        let shapeLayer = CAShapeLayer()
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: topIndent))
        path.addCurve(to: CGPoint(x: frame.maxX, y: topIndent),
                      control1: CGPoint(x: frame.maxX/2 - centerIntendWave, y: topIndent),
                      control2: CGPoint(x: frame.maxX/2 + centerIntendWave, y: topIndent - verticalIntendWave))
        path.addLine(to: CGPoint(x: frame.maxX, y: 0))
        path.addLine(to: CGPoint(x: frame.minX, y: 0))

        shapeLayer.path = path
        shapeLayer.fillColor = backgroundShapeColor.cgColor
        layer.addSublayer(shapeLayer)
    }
}
