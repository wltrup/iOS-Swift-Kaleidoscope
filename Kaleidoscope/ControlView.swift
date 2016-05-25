//
//  ControlView.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


@objc
protocol ControlViewDelegate
{
    func controlViewDidChangeNumRegionsTo(numRegions: Int)
    func controlViewDidChangeNumItemsPerRegionsTo(numItemsPerRegion: Int)
}


class ControlView: UIView
{
    weak var delegate: ControlViewDelegate?

    func updateWithViewModel(viewModel: ViewModel)
    {
        let numRegions = viewModel.numRegions
        numRegionsLabel?.text = "\(numRegions)"
        numRegionsStepper?.value = Double(numRegions)

        let numItemsPerRegion = viewModel.numItemsPerRegion
        numItemsLabel?.text = "\(numItemsPerRegion)"
        numItemsStepper?.value = Double(numItemsPerRegion)
    }

    @IBOutlet private weak var numRegionsLabel: UILabel!
    @IBOutlet private weak var   numItemsLabel: UILabel!

    @IBOutlet private weak var numRegionsStepper: UIStepper!
    @IBOutlet private weak var   numItemsStepper: UIStepper!

    @IBAction private func stepperValueChanged(sender: UIStepper)
    {
        let numRegions = Int(numRegionsStepper.value)
        let numItemsPerRegion = Int(numItemsStepper.value)
        let viewModel = ViewModel(numRegions: numRegions, numItemsPerRegion: numItemsPerRegion)
        updateWithViewModel(viewModel)

        switch sender
        {
        case numRegionsStepper: delegate?.controlViewDidChangeNumRegionsTo(numRegions)
        case   numItemsStepper: delegate?.controlViewDidChangeNumItemsPerRegionsTo(numItemsPerRegion)
        default: break
        }
    }
}
