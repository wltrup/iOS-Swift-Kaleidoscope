//
//  KaleidoscopeModel.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


class KaleidoscopeModel: NSObject
{
    let worldCenter: CGPoint
    let worldRadius: CGFloat

    init(worldCenter: CGPoint, worldRadius: CGFloat)
    {
        self.worldCenter = worldCenter
        self.worldRadius = worldRadius
        super.init()
    }

    var numRegions: Int = 4
    var numItemsPerRegion: Int = 5
    
//    let alpha: CGFloat
//    let items: [Item]

//    var dynamicAnimator = UIDynamicAnimator()

//    init(numRegions: Int = 4, numItemsPerRegion: Int = 5, center: CGPoint, radius: CGFloat)
//    {
//        assert(numRegions > 0, "invalid number of regions (\(numRegions))")
//        self.numRegions = numRegions
//        self.alpha = 2 * CGFloat(M_PI) / CGFloat(numRegions)
//
//        assert(numItemsPerRegion > 0, "invalid number of items (\(numItemsPerRegion))")
//        self.numItemsPerRegion = numItemsPerRegion
//
//        let lambda: CGFloat = 0.25
//        let oneMinusLambda = 1 - lambda
//
//        let minBeta = lambda * self.alpha
//        let maxBeta = oneMinusLambda * self.alpha
//        var betas = [CGFloat]()
//
//        let minRadius = lambda * radius
//        let maxRadius = oneMinusLambda * radius
//        var radii = [CGFloat]()
//
//        for _ in 0 ..< numItemsPerRegion
//        {
//            let beta = CGFloat.randomUniform(a: minBeta, b: maxBeta)
//            betas.append(beta)
//
//            let r = CGFloat.randomUniform(a: minRadius, b: maxRadius)
//            radii.append(r)
//        }
//
//        var tempItems = [Item]()
//        let pairs = zip(radii, betas)
//        for (radius, beta) in pairs
//        {
//            let x = center.x + radius * cos(beta)
//            let y = center.y - radius * sin(beta)
//            let item = Item(center: CGPoint(x: x, y: y), r: radius, beta: beta)
//            tempItems.append(item)
//        }
//        self.items = tempItems
//
//        super.init()
//
////        let gravityBehavior = UIGravityBehavior(items: self.items)
////        self.dynamicAnimator.addBehavior(gravityBehavior)
////
////        let collisionBehavior = UICollisionBehavior(items: self.items)
////        self.dynamicAnimator.addBehavior(collisionBehavior)
//    }
}


//class Item: NSObject, UIDynamicItem
//{
//    static let SIZE: CGFloat = 20
//
//    var isCircle = true
//    var color = UIColor.blackColor()
//
//    var center: CGPoint
//    var transform: CGAffineTransform = CGAffineTransformIdentity
//
//    var bounds: CGRect { return CGRect(x: 0, y: 0, width: Item.SIZE, height: Item.SIZE) }
//
//    let radius: CGFloat
//
//    let r: CGFloat
//    let beta: CGFloat
//
//    init(center: CGPoint, r: CGFloat, beta: CGFloat)
//    {
//        self.isCircle = CGFloat.randomBool
//        self.radius = Item.SIZE / 2
//
//        self.r = r
//        self.beta = beta
//
//        self.color = UIColor.randomColor()
//
//        self.center = center
//        super.init()
//    }
//
//    var collisionBoundsType: UIDynamicItemCollisionBoundsType
//    { return self.isCircle ? .Ellipse : .Rectangle }
//}
