//
//  KaleidoscopeViewController.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit

class KaleidoscopeViewController: UIViewController
{
    @IBOutlet weak var kaleidoscopeView: KaleidoscopeView!
    @IBOutlet weak var controlView: ControlView! {
        didSet { controlView.delegate = self }
    }

//    override func viewWillAppear(animated: Bool)
//    {
//        super.viewWillAppear(animated)
//
//        let (center, radius) = self.controlViewNeedsViewCenterAndRadius(controlView)
//        let initialKaleidoscopeModel = KaleidoscopeModel(center: center, radius: radius)
//
//        controlView.updateWithModel(initialKaleidoscopeModel)
//        kaleidoscopeView.updateWithModel(initialKaleidoscopeModel)
//    }
}

extension KaleidoscopeViewController: ControlViewDelegate
{
    func controlViewDidChangeNumRegionsTo(numRegions: Int)
    {
        // XXX
        print("numRegions: \(numRegions)")
    }

    func controlViewDidChangeNumItemsPerRegionsTo(numItemsPerRegion: Int)
    {
        // XXX
        print("numItemsPerRegion: \(numItemsPerRegion)")
    }
}