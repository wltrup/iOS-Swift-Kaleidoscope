//
//  KaleidoscopeEngine.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


@objc
protocol KaleidoscopeEngineDelegate
{
    func kaleidoscopeEngineDidUpdateState()
}


class KaleidoscopeEngine
{
    weak var delegate: KaleidoscopeEngineDelegate?

    var worldCenter: CGPoint!
    var worldRadius: CGFloat!

    var configuration = Configuration()
    struct Configuration
    {
        var numRegions: Int = 3
        var numItemsPerRegion: Int = 5
        var itemSize: CGFloat = 5
        var itemElasticity: CGFloat = 1.0
    }

    func start()
    {
        // XXX
    }

    func stop()
    {
        // XXX
    }
}


//@objc
//protocol KaleidoscopeModelDelegate
//{
//    func kaleidoscopeModelDidUpdate(model: KaleidoscopeModel)
//}
//
//
//class KaleidoscopeModel: NSObject
//{
//    weak var delegate: KaleidoscopeModelDelegate?
//
//    var worldCenter: CGPoint! { didSet { resetState() } }
//    var worldRadius: CGFloat! { didSet { resetState() } }
//
//    var numRegions:        Int = 4 { didSet { resetState() } }
//    var numItemsPerRegion: Int = 5 { didSet { resetState() } }
//
//    private(set) var regionAngle: CGFloat!
//
//    private(set) var items = [Item]()
//    private let dynamicAnimator = UIDynamicAnimator()
//
//    private func resetState()
//    {
//        guard worldCenter != nil && worldRadius != nil else { return }
//
//        assert(numRegions > 0, "invalid number of regions (\(numRegions))")
//        assert(numItemsPerRegion > 0, "invalid number of items (\(numItemsPerRegion))")
//
//        regionAngle = 2 * CGFloat(M_PI) / CGFloat(numRegions)
//        createItems()
//        resetDynamicAnimator()
//
//        delegate?.kaleidoscopeModelDidUpdate(self)
//    }
//
//    private func createItems()
//    {
//        let lambda: CGFloat = 0.25
//        let oneMinusLambda = 1 - lambda
//
//        let minTheta = lambda * regionAngle
//        let maxTheta = oneMinusLambda * regionAngle
//        var thetas = [CGFloat]()
//
//        let minRadius = lambda * worldRadius
//        let maxRadius = oneMinusLambda * worldRadius
//        var rs = [CGFloat]()
//
//        for _ in 0 ..< numItemsPerRegion
//        {
//            let theta = CGFloat.randomUniform(a: minTheta, b: maxTheta)
//            thetas.append(theta)
//
//            let r = CGFloat.randomUniform(a: minRadius, b: maxRadius)
//            rs.append(r)
//        }
//
//        items = []
//        let pairs = zip(rs, thetas)
//        for (r, theta) in pairs
//        {
//            let item = Item(worldCenter: worldCenter, r: r, theta: theta)
//            item.delegate = self
//            items.append(item)
//        }
//    }
//
//    private func resetDynamicAnimator()
//    {
//        dynamicAnimator.removeAllBehaviors()
//
//        let gravityBehavior = UIGravityBehavior(items: items)
//        dynamicAnimator.addBehavior(gravityBehavior)
//
//        let dynamicItemBehavior = UIDynamicItemBehavior(items: items)
//        dynamicItemBehavior.elasticity = 1.0
//        dynamicAnimator.addBehavior(dynamicItemBehavior)
//
//        let collisionBehavior = UICollisionBehavior(items: items)
//        collisionBehavior.addBoundaryWithIdentifier("region boundary", forPath: regionBoundaryPath())
//        dynamicAnimator.addBehavior(collisionBehavior)
//    }
//
//    func regionBoundaryPath() -> UIBezierPath
//    {
//        if numRegions == 1
//        {
//            return UIBezierPath(arcCenter: worldCenter, radius: worldRadius,
//                                startAngle: 0, endAngle: regionAngle, clockwise: true)
//        }
//        else
//        {
//            let path = UIBezierPath()
//            path.moveToPoint(worldCenter)
//
//            let p = CGPoint(x: worldCenter.x + worldRadius * cos(regionAngle),
//                            y: worldCenter.y - worldRadius * sin(regionAngle))
//            path.addLineToPoint(p)
//
//            let startAngle = CGFloat(numRegions-1) * regionAngle
//            let   endAngle = CGFloat(numRegions)   * regionAngle
//            path.addArcWithCenter(worldCenter, radius: worldRadius,
//                                  startAngle: startAngle, endAngle: endAngle, clockwise: true)
//
//            path.addLineToPoint(worldCenter)
//            return path
//        }
//    }
//}
//
//
//extension KaleidoscopeModel: ItemDelegate
//{
//    func itemDidUpdate(item: Item)
//    { delegate?.kaleidoscopeModelDidUpdate(self) }
//}
//
//
//@objc
//protocol ItemDelegate
//{
//    func itemDidUpdate(item: Item)
//}
//
//
//class Item: NSObject, UIDynamicItem
//{
//    static var size: CGFloat = 5
//    static let TWO_PI = CGFloat(2*M_PI)
//
//    weak var delegate: ItemDelegate?
//    var color = UIColor.whiteColor()
//
//    var transform: CGAffineTransform = CGAffineTransformIdentity
//    var center: CGPoint { didSet { delegate?.itemDidUpdate(self) } }
//
//    var bounds: CGRect { return CGRect(x: 0, y: 0, width: Item.size, height: Item.size) }
//
//    var r: CGFloat
//    {
//        let dx = center.x - worldCenter.x
//        let dy = center.y - worldCenter.y
//        return sqrt(dx * dx + dy * dy)
//    }
//
//    var theta: CGFloat
//    {
//        let dx = center.x - worldCenter.x
//        let dy = center.y - worldCenter.y
//        return (Item.TWO_PI - atan2(dy, dx)) % Item.TWO_PI
//    }
//
//    let worldCenter: CGPoint
//
//    init(worldCenter: CGPoint, r: CGFloat, theta: CGFloat)
//    {
//        self.worldCenter = worldCenter
//        self.color = UIColor.randomColor()
//        let x = worldCenter.x + r * cos(theta)
//        let y = worldCenter.y - r * sin(theta)
//        self.center = CGPoint(x: x, y: y)
//        super.init()
//    }
//
//    var collisionBoundsType: UIDynamicItemCollisionBoundsType
//    { return .Ellipse }
//}
