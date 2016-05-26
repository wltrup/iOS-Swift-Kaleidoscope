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
    func showAllRegionsDidChangeTo(showAllRegions: Bool)
    func showRefRegionDidChangeTo(showRefRegion: Bool)
    func numRegionsDidChangeTo(numRegions: Int)
    func numItemsPerRegionsDidChangeTo(numItemsPerRegion: Int)
    func itemSizeDidChangeTo(itemSize: CGFloat)
    func itemElasticityDidChangeTo(itemElasticity: CGFloat)
}


class ControlsViewController: UITableViewController
{
    @IBOutlet private weak var numRegionsLabel:          UILabel!
    @IBOutlet private weak var numItemsPerRegionLabel:   UILabel!
    @IBOutlet private weak var itemSizeLabel:            UILabel!
    @IBOutlet private weak var itemElasticityLabel:      UILabel!
    @IBOutlet private weak var numRegionsStepper:        UIStepper!
    @IBOutlet private weak var numItemsPerRegionStepper: UIStepper!
    @IBOutlet private weak var itemSizeSlider:           UISlider!
    @IBOutlet private weak var itemElasticitySlider:     UISlider!
    @IBOutlet private weak var showAllRegionsSwitch:     UISwitch!
    @IBOutlet private weak var showRefRegionSwitch:      UISwitch!

    weak var delegate: ControlsViewControllerDelegate?

    var viewModel: ViewModel!
    struct ViewModel
    {
        let showAllRegions:    Bool
        let showRefRegion:     Bool
        let numRegions:        ValueInRange<Int>
        let numItemsPerRegion: ValueInRange<Int>
        let itemSize:          ValueInRange<CGFloat>
        let itemElasticity:    ValueInRange<CGFloat>

        static var itemElasticityNumberFormatter: NSNumberFormatter
        {
            let formatter = NSNumberFormatter()
            formatter.minimumIntegerDigits = 1
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter
        }
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        updateUI()
    }
}


extension ControlsViewController
{
    private func updateUI()
    {
        guard viewModel != nil else { fatalError("ControlsViewController: view model not set") }

        let showAllRegions = viewModel.showAllRegions
        showAllRegionsSwitch.on = showAllRegions

        let showRefRegion = viewModel.showRefRegion
        showRefRegionSwitch.on = showRefRegion

        let numRegions = viewModel.numRegions
        numRegionsLabel.text = "\(numRegions.cur)"
        numRegionsStepper.minimumValue = Double(numRegions.min)
        numRegionsStepper.maximumValue = Double(numRegions.max)
        numRegionsStepper.value = Double(numRegions.cur)

        let numItemsPerRegion = viewModel.numItemsPerRegion
        numItemsPerRegionLabel.text = "\(numItemsPerRegion.cur)"
        numItemsPerRegionStepper.minimumValue = Double(numItemsPerRegion.min)
        numItemsPerRegionStepper.maximumValue = Double(numItemsPerRegion.max)
        numItemsPerRegionStepper.value = Double(numItemsPerRegion.cur)

        let itemSize = viewModel.itemSize
        itemSizeLabel.text = "\(Int(itemSize.cur))"
        itemSizeSlider.minimumValue = Float(itemSize.min)
        itemSizeSlider.maximumValue = Float(itemSize.max)
        itemSizeSlider.value = Float(itemSize.cur)

        let itemElasticity = viewModel.itemElasticity
        itemElasticityLabel.text = ViewModel.itemElasticityNumberFormatter.stringFromNumber(itemElasticity.cur)
        itemElasticitySlider.minimumValue = Float(itemElasticity.min)
        itemElasticitySlider.maximumValue = Float(itemElasticity.max)
        itemElasticitySlider.value = Float(itemElasticity.cur)
    }

    @IBAction private func stepperValueChanged(sender: UIStepper)
    {
        switch sender
        {
        case numRegionsStepper:
            let numRegions = Int(numRegionsStepper.value)
            numRegionsLabel.text = "\(numRegions)"
            delegate?.numRegionsDidChangeTo(numRegions)
        case numItemsPerRegionStepper:
            let numItemsPerRegion = Int(numItemsPerRegionStepper.value)
            numItemsPerRegionLabel.text = "\(numItemsPerRegion)"
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
            itemSizeLabel.text = "\(Int(itemSize))"
            delegate?.itemSizeDidChangeTo(itemSize)
        case itemElasticitySlider:
            let itemElasticity = CGFloat(itemElasticitySlider.value)
            itemElasticityLabel.text = ViewModel.itemElasticityNumberFormatter.stringFromNumber(itemElasticity)
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
        case showAllRegionsSwitch:
            let showAllRegions = showAllRegionsSwitch.on
            delegate?.showAllRegionsDidChangeTo(showAllRegions)
        case showRefRegionSwitch:
            let showRefRegion = showRefRegionSwitch.on
            delegate?.showRefRegionDidChangeTo(showRefRegion)
        default:
            fatalError("Unhandled sender in call to switchValueChanged(:)")
            break
        }
    }
}
