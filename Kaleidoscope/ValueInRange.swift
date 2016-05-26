//
//  ValueInRange.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


struct ValueInRange<T: Comparable>
{
    let min: T
    let max: T
    let cur: T

    init(min: T, max: T, cur: T)
    {
        guard min <= cur && cur <= max else
        { fatalError("'(\(min), \(cur), \(max))' do not satisfy \(min) ≤ \(cur) ≤ \(max)") }

        self.min = min
        self.max = max
        self.cur = cur
    }
}
