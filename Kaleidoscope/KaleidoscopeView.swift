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
    var kaleidoscopeModel: KaleidoscopeModel!
    
    var viewRadius: CGFloat
    {
        let w = bounds.size.width
        let h = bounds.size.height
        return 0.95 * (w <= h ? w : h) / 2
    }

    var viewCenter: CGPoint
    { return CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds)) }
    
    override func drawRect(rect: CGRect)
    {
        guard kaleidoscopeModel != nil else { return }

        let worldCenter = kaleidoscopeModel.worldCenter
        let worldRadius = kaleidoscopeModel.worldRadius

        let N = kaleidoscopeModel.numRegions
        let regionAngle = kaleidoscopeModel.regionAngle

        let items = kaleidoscopeModel.items

        drawCircleAt(worldCenter, radius: worldRadius, strokeColor: UIColor.whiteColor())
        if N > 1 { drawRadialLines(numLines: N, centerPoint: worldCenter, radius: worldRadius, angle: regionAngle) }

        // drawElementaryRegion()

        let maxN = (N % 2 == 0 ? N : 2 * N)
        for item in items
        {
            fillItem(item)

            let r = item.r
            let theta = item.theta

            for n in 0 ..< maxN
            {
                let alpha_n = (N % 2 == 0 ? CGFloat(n) * regionAngle : CGFloat(n) * regionAngle / 2)

                if N > 1
                {
                    let theta_n = 2 * alpha_n - theta
                    let point = pointOffsetFromPointAtCenter(worldCenter, withRadius: r, andAngle: theta_n)
                    drawCircleAt(point, radius: Item.SIZE/2, fillColor: item.color)
                }

                let theta_n = 2 * alpha_n + theta
                let point = pointOffsetFromPointAtCenter(worldCenter, withRadius: r, andAngle: theta_n)
                drawCircleAt(point, radius: Item.SIZE/2, fillColor: item.color)
            }
        }
    }
}

extension KaleidoscopeView
{
    private func drawElementaryRegion()
    {
        let path = kaleidoscopeModel.regionBoundaryPath()
        UIColor.blueColor().setStroke()
        path.stroke()
        UIColor.redColor().colorWithAlphaComponent(0.1).setFill()
        path.fill()
    }

    private func pointOffsetFromPointAtCenter(centerPoint: CGPoint,
                                              withRadius radius: CGFloat,
                                                         andAngle angle: CGFloat) -> CGPoint
    {
        let x = centerPoint.x + radius * cos(angle)
        let y = centerPoint.y - radius * sin(angle)
        return CGPoint(x: x, y: y)
    }

    private func fillItem(item: Item)
    { drawCircleAt(x: item.center.x, y: item.center.y, radius: Item.SIZE/2, strokeColor: nil, fillColor: item.color) }

    private func drawCircleAt(p: CGPoint, radius: CGFloat, strokeColor: UIColor? = nil, fillColor: UIColor? = nil)
    { drawCircleAt(x: p.x, y: p.y, radius: radius, strokeColor: strokeColor, fillColor: fillColor) }

    private func drawCircleAt(x x: CGFloat, y: CGFloat, radius: CGFloat,
                                strokeColor: UIColor? = nil, fillColor: UIColor? = nil)
    {
        let diameter = 2*radius
        let origin = CGPoint(x: x - radius, y: y - radius)
        let size = CGSize(width: diameter, height: diameter)
        let rect = CGRect(origin: origin, size: size)
        let circle = UIBezierPath(ovalInRect: rect)
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

    private func drawRadialLines(numLines N: Int, centerPoint: CGPoint,
                                          radius: CGFloat, angle: CGFloat,
                                          strokeColor: UIColor? = nil)
    {
        let path = UIBezierPath()
        for n in 0 ..< N
        {
            let theta = CGFloat(n) * angle
            let point = pointOffsetFromPointAtCenter(centerPoint, withRadius: radius, andAngle: theta)
            path.moveToPoint(centerPoint)
            path.addLineToPoint(point)
        }
        (strokeColor ?? UIColor.whiteColor()).setStroke()
        path.stroke()
    }
}

