//
//  ViewController.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    private var kaleidoscopeModel: KaleidoscopeModel!

    @IBOutlet private weak var kaleidoscopeView: KaleidoscopeView!
    @IBOutlet private weak var controlView: ControlView! {
        didSet { controlView.delegate = self }
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)

        let viewCenter = kaleidoscopeView.viewCenter
        let viewRadius = kaleidoscopeView.viewRadius
        kaleidoscopeModel = KaleidoscopeModel(worldCenter: viewCenter, worldRadius: viewRadius)

        let numRegions = kaleidoscopeModel.numRegions
        let numItemsPerRegion = kaleidoscopeModel.numItemsPerRegion
        let controlViewModel = ControlViewModel(numRegions: numRegions, numItemsPerRegion: numItemsPerRegion)
        controlView.updateWithViewModel(controlViewModel)

//        kaleidoscopeView.updateWithModel(initialKaleidoscopeModel)
    }
}

extension ViewController: ControlViewDelegate
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