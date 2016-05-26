//
//  KaleidoscopeEngine.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit

private let TWO_PI = CGFloat(2*M_PI)


@objc
protocol KaleidoscopeEngineDelegate
{
    func kaleidoscopeEngineDidUpdateState()
}


class KaleidoscopeEngine: NSObject
{
    weak var delegate: KaleidoscopeEngineDelegate?

    var worldCenter: CGPoint! { didSet { resetState() } }
    var worldRadius: CGFloat! { didSet { resetState() } }

    struct Configuration
    {
        var numRegions: Int = 3
        var numItemsPerRegion: Int = 5
        var itemSize: CGFloat = 5
        var itemElasticity: CGFloat = 1.0
        var delegateUpdateInterval: NSTimeInterval = 1.0/60.0 // 60 updates per second
    }
    var configuration = Configuration() {
        didSet
        {
            if configuration.numRegions != oldValue.numRegions ||
                configuration.numItemsPerRegion != oldValue.numItemsPerRegion
            { resetState() }

            if configuration.itemElasticity != oldValue.itemElasticity
            { dynamicItemBehavior?.elasticity = configuration.itemElasticity }
        }
    }

    private var regionAngle: CGFloat!
    private var items = [Item]()

    private var dynamicAnimator: UIDynamicAnimator!
    private var dynamicItemBehavior: UIDynamicItemBehavior!
    private var timeOfLastDelegateUpdate: NSTimeInterval = 0

    struct Data
    {
        let numRegions: Int
        let numItemsPerRegion: Int
        let worldCenter: CGPoint
        let worldRadius: CGFloat
        let regionAngle: CGFloat
        let items = [Item]()
    }
    var dataForRendering: Data
    {
        return Data(
            numRegions: configuration.numRegions,
            numItemsPerRegion: configuration.numItemsPerRegion,
            worldCenter: worldCenter,
            worldRadius: worldRadius,
            regionAngle: regionAngle
        )
    }

    func start()
    { startDynamicAnimator() }

    func stop()
    { stopDynamicAnimator() }
}


extension KaleidoscopeEngine
{
    private func resetState()
    {
        guard worldCenter != nil && worldRadius != nil else { return }

        let numRegions = configuration.numRegions
        assert(numRegions > 0, "invalid number of regions (\(numRegions))")

        let numItemsPerRegion = configuration.numItemsPerRegion
        assert(numItemsPerRegion > 0, "invalid number of items per region (\(numItemsPerRegion))")

        stopDynamicAnimator()

        regionAngle = TWO_PI / CGFloat(numRegions)
        createItems()

        startDynamicAnimator()
    }

    private func createItems()
    {
        guard worldCenter != nil else { fatalError("worldCenter not set") }
        guard worldRadius != nil else { fatalError("worldRadius not set") }
        guard regionAngle != nil else { fatalError("regionAngle not set") }

        let lambda: CGFloat = 0.25
        let oneMinusLambda = 1 - lambda

        let minTheta = lambda * regionAngle
        let maxTheta = oneMinusLambda * regionAngle
        var thetas = [CGFloat]()

        let minRadius = lambda * worldRadius
        let maxRadius = oneMinusLambda * worldRadius
        var rs = [CGFloat]()

        let numItemsPerRegion = configuration.numItemsPerRegion
        for _ in 0 ..< numItemsPerRegion
        {
            let theta = CGFloat.randomUniform(a: minTheta, b: maxTheta)
            thetas.append(theta)

            let r = CGFloat.randomUniform(a: minRadius, b: maxRadius)
            rs.append(r)
        }

        items = []
        let pairs = zip(rs, thetas)
        for (r, theta) in pairs
        {
            let item = Item(worldCenter: worldCenter, r: r, theta: theta)
            item.delegate = self
            items.append(item)
        }
    }

    private func startDynamicAnimator()
    {
        dynamicAnimator = UIDynamicAnimator()

        dynamicItemBehavior = UIDynamicItemBehavior(items: items)
        dynamicItemBehavior.elasticity = configuration.itemElasticity
        dynamicItemBehavior.allowsRotation = true
        dynamicAnimator.addBehavior(dynamicItemBehavior)

        let collisionBehavior = UICollisionBehavior(items: items)
        collisionBehavior.addBoundaryWithIdentifier("region boundary", forPath: regionBoundaryPath())
        dynamicAnimator.addBehavior(collisionBehavior)

        let gravityBehavior = UIGravityBehavior(items: items)
        dynamicAnimator.addBehavior(gravityBehavior)
    }

    private func stopDynamicAnimator()
    {
        if let animator = dynamicAnimator
        {
            animator.removeAllBehaviors()
            dynamicItemBehavior = nil
            dynamicAnimator = nil
        }
    }

    private func regionBoundaryPath() -> UIBezierPath
    {
        let numRegions = configuration.numRegions

        if numRegions == 1
        {
            return UIBezierPath(arcCenter: worldCenter, radius: worldRadius,
                                startAngle: 0, endAngle: regionAngle, clockwise: true)
        }
        else
        {
            let path = UIBezierPath()
            path.moveToPoint(worldCenter)

            let p = CGPoint(x: worldCenter.x + worldRadius * cos(regionAngle),
                            y: worldCenter.y - worldRadius * sin(regionAngle))
            path.addLineToPoint(p)

            let startAngle = CGFloat(numRegions-1) * regionAngle
            let   endAngle = CGFloat(numRegions)   * regionAngle
            path.addArcWithCenter(worldCenter, radius: worldRadius,
                                  startAngle: startAngle, endAngle: endAngle, clockwise: true)

            path.addLineToPoint(worldCenter)
            return path
        }
    }
}


extension KaleidoscopeEngine: ItemDelegate
{
    func itemSize() -> CGFloat
    { return configuration.itemSize }

    func itemStateDidChange()
    {
        guard dynamicAnimator != nil else { return }

        let elapsedTime = dynamicAnimator.elapsedTime()
        let timeSinceLastDelegateUpdate = elapsedTime - timeOfLastDelegateUpdate
        if timeSinceLastDelegateUpdate >= configuration.delegateUpdateInterval
        {
            timeOfLastDelegateUpdate = elapsedTime
            delegate?.kaleidoscopeEngineDidUpdateState()
        }
    }
}


@objc
protocol ItemDelegate
{
    func itemSize() -> CGFloat
    func itemStateDidChange()
}


class Item: NSObject, UIDynamicItem
{
    weak var delegate: ItemDelegate?

    var center: CGPoint
        { didSet { delegate?.itemStateDidChange() } }

    var transform: CGAffineTransform = CGAffineTransformIdentity
        { didSet { delegate?.itemStateDidChange() } }

    var bounds: CGRect { return CGRect(x: 0, y: 0, width: size, height: size) }
    var size: CGFloat { return (delegate != nil ? delegate!.itemSize() : 5) }

    var collisionBoundsType: UIDynamicItemCollisionBoundsType
    { return .Ellipse }

    let worldCenter: CGPoint
    let color: UIColor

    var r: CGFloat
    {
        let dx = center.x - worldCenter.x
        let dy = center.y - worldCenter.y
        return sqrt(dx * dx + dy * dy)
    }

    var theta: CGFloat
    {
        let dx = center.x - worldCenter.x
        let dy = center.y - worldCenter.y
        return (TWO_PI - atan2(dy, dx)) % TWO_PI
    }

    private init(worldCenter: CGPoint, r: CGFloat, theta: CGFloat)
    {
        self.worldCenter = worldCenter
        self.color = UIColor.randomColor()
        let x = worldCenter.x + r * cos(theta)
        let y = worldCenter.y - r * sin(theta)
        self.center = CGPoint(x: x, y: y)
        super.init()
    }
}
