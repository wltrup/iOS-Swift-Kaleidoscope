//
//  ControlsViewController.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


@objc
protocol ControlsViewControllerDelegate
{
    func showRegionsDidChangeTo(showRegions: Bool)
    func numRegionsDidChangeTo(numRegions: Int)
    func numItemsPerRegionsDidChangeTo(numItemsPerRegion: Int)
    func itemSizeDidChangeTo(itemSize: CGFloat)
    func itemElasticityDidChangeTo(itemElasticity: CGFloat)
}


class ControlsViewController: UITableViewController
{
    weak var delegate: ControlsViewControllerDelegate?
    var model: Model!

    struct Model
    {
        let showRegions: Bool
        let numRegions: Int
        let numItemsPerRegion: Int
        let itemSize: CGFloat
        let itemElasticity: CGFloat
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        updateUI()
    }

    @IBOutlet private weak var numRegionsLabel:          UILabel!
    @IBOutlet private weak var numItemsPerRegionLabel:   UILabel!
    @IBOutlet private weak var itemSizeLabel:            UILabel!
    @IBOutlet private weak var itemElasticityLabel:      UILabel!
    @IBOutlet private weak var numRegionsStepper:        UIStepper!
    @IBOutlet private weak var numItemsPerRegionStepper: UIStepper!
    @IBOutlet private weak var itemSizeSlider:           UISlider!
    @IBOutlet private weak var itemElasticitySlider:     UISlider!
    @IBOutlet private weak var showRegionsSwitch:        UISwitch!
}


extension ControlsViewController
{
    private func updateUI()
    {
        guard model != nil else { fatalError("ControlsViewController model not set") }

        let showRegions = model.showRegions
        showRegionsSwitch.on = showRegions

        let numRegions = model.numRegions
        numRegionsLabel?.text = "\(numRegions)"
        numRegionsStepper?.value = Double(numRegions)

        let numItemsPerRegion = model.numItemsPerRegion
        numItemsPerRegionLabel?.text = "\(numItemsPerRegion)"
        numItemsPerRegionStepper?.value = Double(numItemsPerRegion)

        let itemSize = model.itemSize
        itemSizeLabel?.text = "\(Int(itemSize))"
        itemSizeSlider?.value = Float(itemSize)

        let itemElasticity = model.itemElasticity
        itemElasticityLabel?.text = ""
        itemElasticitySlider?.value = Float(itemElasticity)
    }

    @IBAction private func stepperValueChanged(sender: UIStepper)
    {
        switch sender
        {
        case numRegionsStepper:
            let numRegions = Int(numRegionsStepper.value)
            delegate?.numRegionsDidChangeTo(numRegions)
        case numItemsPerRegionStepper:
            let numItemsPerRegion = Int(numItemsPerRegionStepper.value)
            delegate?.numItemsPerRegionsDidChangeTo(numItemsPerRegion)
        default:
            fatalError("Unhandled sender in call to stepperValueChanged(:)")
            break
        }
    }

    @IBAction private func sliderValueChanged(sender: UISlider)
    {
        switch sender
        {
        case itemSizeSlider:
            let itemSize = CGFloat(itemSizeSlider.value)
            delegate?.itemSizeDidChangeTo(itemSize)
        case itemElasticitySlider:
            let itemElasticity = CGFloat(itemElasticitySlider.value)
            delegate?.itemElasticityDidChangeTo(itemElasticity)
        default:
            fatalError("Unhandled sender in call to sliderValueChanged(:)")
            break
        }
    }

    @IBAction private func switchValueChanged(sender: UISwitch)
    {
        switch sender
        {
        case showRegionsSwitch:
            let showRegions = showRegionsSwitch.on
            delegate?.showRegionsDidChangeTo(showRegions)
        default:
            fatalError("Unhandled sender in call to switchValueChanged(:)")
            break
        }
    }
}
