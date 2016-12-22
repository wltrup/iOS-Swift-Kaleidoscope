//
//  KaleidoscopeView.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


class KaleidoscopeView: UIView
{
    var items: [Item] = []
        { didSet { setNeedsDisplay() } }

    var showAllRegions = false
        { didSet { setNeedsDisplay() } }

    var showRefRegion  = false
        { didSet { setNeedsDisplay() } }

    var numRegions: Int!
        { didSet { setNeedsDisplay() } }

    var regionAngle: CGFloat!
        { didSet { setNeedsDisplay() } }

    var regionBoundaryPath: UIBezierPath?
        { didSet { setNeedsDisplay() } }

    var viewRadius: CGFloat
    {
        let w = bounds.size.width
        let h = bounds.size.height
        return 0.95 * (w <= h ? w : h) / 2
    }

    var viewCenter: CGPoint
    { return CGPoint(x: bounds.midX, y: bounds.midY) }

    override func draw(_ rect: CGRect)
    {
        guard self.numRegions != nil else { return }
        let numRegions = self.numRegions!

        guard self.regionAngle != nil else { return }
        let regionAngle = self.regionAngle!

        if showAllRegions
        {
            drawCircleAt(viewCenter, radius: viewRadius, strokeColor: UIColor.white)

            if numRegions > 1
            { drawRadialLines(numLines: numRegions, centerPoint: viewCenter, radius: viewRadius, angle: regionAngle) }
        }

        if showRefRegion { drawReferenceRegion() }

        let maxNumRegions = (numRegions % 2 == 0 ? numRegions : 2 * numRegions)
        for item in items
        {
            fillItem(item)

            let r = item.r
            let theta = item.theta

            for n in 0 ..< maxNumRegions
            {
                let alpha_n = (numRegions % 2 == 0 ? CGFloat(n) * regionAngle : CGFloat(n) * regionAngle / 2)

                if numRegions > 1
                {
                    let theta_n = 2 * alpha_n - theta
                    let point = pointOffsetFromPointAtCenter(viewCenter, withRadius: r, andAngle: theta_n)
                    drawCircleAt(point, radius: item.size/2, fillColor: item.color)
                }

                let theta_n = 2 * alpha_n + theta
                let point = pointOffsetFromPointAtCenter(viewCenter, withRadius: r, andAngle: theta_n)
                drawCircleAt(point, radius: item.size/2, fillColor: item.color)
            }
        }
    }
}


extension KaleidoscopeView
{
    fileprivate func drawReferenceRegion()
    {
        if let path = self.regionBoundaryPath
        {
            UIColor.white.setStroke()
            path.stroke()
            UIColor.red.withAlphaComponent(0.1).setFill()
            path.fill()
        }
    }

    fileprivate func fillItem(_ item: Item)
    { drawCircleAt(x: item.center.x, y: item.center.y, radius: item.size/2, strokeColor: nil, fillColor: item.color) }

    fileprivate func drawCircleAt(_ p: CGPoint, radius: CGFloat, strokeColor: UIColor? = nil, fillColor: UIColor? = nil)
    { drawCircleAt(x: p.x, y: p.y, radius: radius, strokeColor: strokeColor, fillColor: fillColor) }

    fileprivate func drawCircleAt(x: CGFloat, y: CGFloat, radius: CGFloat,
                                strokeColor: UIColor? = nil, fillColor: UIColor? = nil)
    {
        let diameter = 2*radius
        let origin = CGPoint(x: x - radius, y: y - radius)
        let size = CGSize(width: diameter, height: diameter)
        let rect = CGRect(origin: origin, size: size)
        let circle = UIBezierPath(ovalIn: rect)
        if strokeColor != nil
        {
            strokeColor!.setStroke()
            circle.stroke()
        }
        if fillColor != nil
        {
            fillColor!.setFill()
            circle.fill()
        }
    }

    fileprivate func drawRadialLines(numLines: Int, centerPoint: CGPoint,
                                          radius: CGFloat, angle: CGFloat,
                                          strokeColor: UIColor? = nil)
    {
        let path = UIBezierPath()
        for n in 0 ..< numLines
        {
            let theta = CGFloat(n) * angle
            let point = pointOffsetFromPointAtCenter(centerPoint, withRadius: radius, andAngle: theta)
            path.move(to: centerPoint)
            path.addLine(to: point)
        }
        (strokeColor ?? UIColor.white).setStroke()
        path.stroke()
    }

    fileprivate func pointOffsetFromPointAtCenter(_ centerPoint: CGPoint,
                                              withRadius radius: CGFloat,
                                                         andAngle angle: CGFloat) -> CGPoint
    {
        let x = centerPoint.x + radius * cos(angle)
        let y = centerPoint.y - radius * sin(angle)
        return CGPoint(x: x, y: y)
    }
}

