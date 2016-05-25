//
//  ViewController.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


struct ViewModel
{
    let numRegions: Int
    let numItemsPerRegion: Int
    let itemSize: CGFloat
    let showRegions: Bool
}


class ViewController: UIViewController
{
    private var kaleidoscopeModel: KaleidoscopeModel! {
        didSet { kaleidoscopeModel.delegate = self }
    }

    @IBOutlet private weak var controlView: ControlView! {
        didSet { controlView.delegate = self }
    }

    @IBOutlet private weak var kaleidoscopeView: KaleidoscopeView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        kaleidoscopeModel = KaleidoscopeModel()
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)

        let viewCenter = kaleidoscopeView.viewCenter
        kaleidoscopeModel.worldCenter = viewCenter

        let viewRadius = kaleidoscopeView.viewRadius
        kaleidoscopeModel.worldRadius = viewRadius

        let numRegions = kaleidoscopeModel.numRegions
        let numItemsPerRegion = kaleidoscopeModel.numItemsPerRegion
        let itemSize = Item.size
        let showRegions = kaleidoscopeView.showRegions

        let viewModel = ViewModel(numRegions: numRegions, numItemsPerRegion: numItemsPerRegion,
                                  itemSize: itemSize, showRegions: showRegions)

        controlView.updateWithViewModel(viewModel)
        kaleidoscopeView.kaleidoscopeModel = kaleidoscopeModel
    }
}


extension ViewController: KaleidoscopeModelDelegate
{
    func kaleidoscopeModelDidUpdate(model: KaleidoscopeModel)
    { kaleidoscopeView?.setNeedsDisplay() }
}


extension ViewController: ControlViewDelegate
{
    func controlViewDidChangeNumRegionsTo(numRegions: Int)
    { kaleidoscopeModel.numRegions = numRegions }

    func controlViewDidChangeNumItemsPerRegionsTo(numItemsPerRegion: Int)
    { kaleidoscopeModel.numItemsPerRegion = numItemsPerRegion }

    func controlViewDidChangeItemSizeTo(itemSize: CGFloat)
    {
        Item.size = itemSize
        kaleidoscopeView?.setNeedsDisplay()
    }

    func controlViewDidChangeShowRegionsTo(showRegions: Bool)
    {
        kaleidoscopeView.showRegions = showRegions
        kaleidoscopeView?.setNeedsDisplay()
    }
}
