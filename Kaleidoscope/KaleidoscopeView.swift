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
    var viewRadius: CGFloat
    {
        let w = bounds.size.width
        let h = bounds.size.height
        return 0.95 * (w <= h ? w : h) / 2
    }

    var viewCenter: CGPoint
    { return CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds)) }
}

//extension KaleidoscopeView
//{
//    var model: KaleidoscopeModel!

//    func updateWithModel(model: KaleidoscopeModel)
//    {
//        self.model = model
//        setNeedsDisplay()
//    }

//    override func drawRect(rect: CGRect)
//    {
//        let N = model.numRegions
//        let alpha = model.alpha
//        let items = model.items
//
//        drawCircleAt(centerPoint, radius: radius, strokeColor: UIColor.blackColor())
//        if N > 1 { drawRadialLines(numLines: N, centerPoint: centerPoint, radius: radius, angle: alpha) }
//
//        let maxN = (N % 2 == 0 ? N : 2 * N)
//        for item in items
//        {
//            let r = item.r
//            let beta = item.beta
//
//            for n in 0 ..< maxN
//            {
//                let alpha_n = (N % 2 == 0 ? CGFloat(n) * alpha : CGFloat(n) * alpha / 2)
//
//                if N > 1
//                {
//                    let beta_n = 2 * alpha_n - beta
//                    let point = pointOffsetFromPointAtCenter(centerPoint, withRadius: r, andAngle: beta_n)
//                    let newItem = Item(center: point, r: r, beta: beta_n)
//                    newItem.color = item.color
//                    newItem.isCircle = item.isCircle
//                    drawItem(newItem)
//                }
//
//                let beta_n = 2 * alpha_n + beta
//                let point = pointOffsetFromPointAtCenter(centerPoint, withRadius: r, andAngle: beta_n)
//                let newItem = Item(center: point, r: r, beta: beta_n)
//                newItem.color = item.color
//                newItem.isCircle = item.isCircle
//                drawItem(newItem)
//            }
//        }
//    }

//    private func drawItem(item: Item)
//    {
//        switch item.collisionBoundsType
//        {
//        case .Ellipse:
//            fillDotCenteredAtPoint(item)
//        case .Rectangle:
//            fillSquareCenteredAtPoint(item)
//        case .Path:
//            break
//        }
//    }
//
//    private func pointOffsetFromPointAtCenter(centerPoint: CGPoint,
//                                              withRadius radius: CGFloat,
//                                                         andAngle angle: CGFloat) -> CGPoint
//    {
//        let x = centerPoint.x + radius * cos(angle)
//        let y = centerPoint.y - radius * sin(angle)
//        return CGPoint(x: x, y: y)
//    }
//
//    private func fillDotCenteredAtPoint(item: Item)
//    { drawCircleAt(x: item.center.x, y: item.center.y, radius: item.radius, strokeColor: nil, fillColor: item.color) }
//
//    private func fillSquareCenteredAtPoint(item: Item)
//    { drawSquareAt(item.center, size: 2*item.radius, strokeColor: nil, fillColor: item.color) }
//
//    private func drawSquareAt(p: CGPoint, size: CGFloat, strokeColor: UIColor? = nil, fillColor: UIColor? = nil)
//    { drawSquareAt(x: p.x, y: p.y, size: size, strokeColor: strokeColor, fillColor: fillColor) }
//
//    private func drawSquareAt(x x: CGFloat, y: CGFloat, size: CGFloat,
//                                strokeColor: UIColor? = nil, fillColor: UIColor? = nil)
//    {
//        let origin = CGPoint(x: x - size/2, y: y - size/2)
//        let cgSize = CGSize(width: size, height: size)
//        let rect = CGRect(origin: origin, size: cgSize)
//        let square = UIBezierPath(rect: rect)
//        if strokeColor != nil
//        {
//            strokeColor!.setStroke()
//            square.stroke()
//        }
//        if fillColor != nil
//        {
//            fillColor!.setFill()
//            square.fill()
//        }
//    }
//
//    private func drawCircleAt(p: CGPoint, radius: CGFloat, strokeColor: UIColor? = nil, fillColor: UIColor? = nil)
//    { drawCircleAt(x: p.x, y: p.y, radius: radius, strokeColor: strokeColor, fillColor: fillColor) }
//
//    private func drawCircleAt(x x: CGFloat, y: CGFloat, radius: CGFloat,
//                                strokeColor: UIColor? = nil, fillColor: UIColor? = nil)
//    {
//        let diameter = 2*radius
//        let origin = CGPoint(x: x - radius, y: y - radius)
//        let size = CGSize(width: diameter, height: diameter)
//        let rect = CGRect(origin: origin, size: size)
//        let circle = UIBezierPath(ovalInRect: rect)
//        if strokeColor != nil
//        {
//            strokeColor!.setStroke()
//            circle.stroke()
//        }
//        if fillColor != nil
//        {
//            fillColor!.setFill()
//            circle.fill()
//        }
//    }
//
//    private func drawRadialLines(numLines N: Int, centerPoint: CGPoint,
//                                          radius: CGFloat, angle: CGFloat,
//                                          strokeColor: UIColor? = nil)
//    {
//        let path = UIBezierPath()
//        for n in 0 ..< N
//        {
//            let theta = CGFloat(n) * angle
//            let point = pointOffsetFromPointAtCenter(centerPoint, withRadius: radius, andAngle: theta)
//            path.moveToPoint(centerPoint)
//            path.addLineToPoint(point)
//        }
//        (strokeColor ?? UIColor.blackColor()).setStroke()
//        path.stroke()
//    }
//}
