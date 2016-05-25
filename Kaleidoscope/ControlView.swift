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
    func controlViewDidChangeItemSizeTo(itemSize: CGFloat)
    func controlViewDidChangeShowRegionsTo(showRegions: Bool)
}


class ControlView: UIView
{
    weak var delegate: ControlViewDelegate?

    func updateWithViewModel(viewModel: ViewModel)
    {
//        let numRegions = viewModel.numRegions
//        numRegionsLabel?.text = "\(numRegions)"
//        numRegionsStepper?.value = Double(numRegions)
//
//        let numItemsPerRegion = viewModel.numItemsPerRegion
//        numItemsLabel?.text = "\(numItemsPerRegion)"
//        numItemsStepper?.value = Double(numItemsPerRegion)
//
//        let itemSize = viewModel.itemSize
//        itemSizeLabel?.text = "\(Int(itemSize))"
//        itemSizeSlider?.value = Float(itemSize)
//
//        let showRegions = viewModel.showRegions
//        showRegionsSwitch.on = showRegions
    }

    @IBOutlet private weak var     numRegionsLabel: UILabel!
    @IBOutlet private weak var       numItemsLabel: UILabel!
    @IBOutlet private weak var       itemSizeLabel: UILabel!
    @IBOutlet private weak var itemElasticityLabel: UILabel!

    @IBOutlet private weak var numRegionsStepper: UIStepper!
    @IBOutlet private weak var   numItemsStepper: UIStepper!

    @IBOutlet private weak var       itemSizeSlider: UISlider!
    @IBOutlet private weak var itemElasticitySlider: UISlider!

    @IBOutlet private weak var showRegionsSwitch: UISwitch!

    @IBAction private func stepperValueChanged(sender: UIStepper)
    {
        createViewModel()

        switch sender
        {
        case numRegionsStepper:
            let numRegions = Int(numRegionsStepper.value)
            delegate?.controlViewDidChangeNumRegionsTo(numRegions)
        case numItemsStepper:
            let numItemsPerRegion = Int(numItemsStepper.value)
            delegate?.controlViewDidChangeNumItemsPerRegionsTo(numItemsPerRegion)
        default:
            break
        }
    }

    @IBAction private func sliderValueChanged(sender: UISlider)
    {
        createViewModel()
        let itemSize = CGFloat(itemSizeSlider.value)
        delegate?.controlViewDidChangeItemSizeTo(itemSize)
    }

    @IBAction private func switchValueChanged()
    {
        createViewModel()
        let showRegions = showRegionsSwitch.on
        delegate?.controlViewDidChangeShowRegionsTo(showRegions)
    }

    private func createViewModel()
    {
        let numRegions = Int(numRegionsStepper.value)
        let numItemsPerRegion = Int(numItemsStepper.value)
        let itemSize = CGFloat(itemSizeSlider.value)
        let showRegions = showRegionsSwitch.on

        let viewModel = ViewModel(numRegions: numRegions, numItemsPerRegion: numItemsPerRegion,
                                  itemSize: itemSize, showRegions: showRegions)

        updateWithViewModel(viewModel)
    }
}
