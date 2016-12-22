//
//  ControlsViewController.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


class SteppableSlider: UISlider
{
    var step: Float = 0
}


@objc
protocol ControlsViewControllerDelegate
{
    func showAllRegionsDidChangeTo(_ showAllRegions: Bool)
    func showRefRegionDidChangeTo(_ showRefRegion: Bool)
    func numRegionsDidChangeTo(_ numRegions: Int)
    func numItemsPerRegionsDidChangeTo(_ numItemsPerRegion: Int)
    func itemSizeDidChangeTo(_ itemSize: CGFloat)
    func itemElasticityDidChangeTo(_ itemElasticity: CGFloat)
}


class ControlsViewController: UITableViewController
{
    @IBOutlet fileprivate weak var numRegionsLabel:          UILabel!
    @IBOutlet fileprivate weak var numItemsPerRegionLabel:   UILabel!
    @IBOutlet fileprivate weak var itemSizeLabel:            UILabel!
    @IBOutlet fileprivate weak var itemElasticityLabel:      UILabel!
    @IBOutlet fileprivate weak var numRegionsStepper:        UIStepper!
    @IBOutlet fileprivate weak var numItemsPerRegionStepper: UIStepper!
    @IBOutlet fileprivate weak var itemSizeSlider:           UISlider!
    @IBOutlet fileprivate weak var itemElasticitySlider:     SteppableSlider!
    @IBOutlet fileprivate weak var showAllRegionsSwitch:     UISwitch!
    @IBOutlet fileprivate weak var showRefRegionSwitch:      UISwitch!

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

        static var itemElasticityNumberFormatter: NumberFormatter
        {
            let formatter = NumberFormatter()
            formatter.minimumIntegerDigits = 1
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        updateUI()
    }
}


extension ControlsViewController
{
    fileprivate func updateUI()
    {
        guard viewModel != nil else { fatalError("ControlsViewController: view model not set") }

        let showAllRegions = viewModel.showAllRegions
        showAllRegionsSwitch.isOn = showAllRegions

        let showRefRegion = viewModel.showRefRegion
        showRefRegionSwitch.isOn = showRefRegion

        let numRegions = viewModel.numRegions
        numRegionsLabel.text = "\(numRegions.current)"
        numRegionsStepper.minimumValue = Double(numRegions.minimum)
        numRegionsStepper.maximumValue = Double(numRegions.maximum)
        numRegionsStepper.value = Double(numRegions.current)

        let numItemsPerRegion = viewModel.numItemsPerRegion
        numItemsPerRegionLabel.text = "\(numItemsPerRegion.current)"
        numItemsPerRegionStepper.minimumValue = Double(numItemsPerRegion.minimum)
        numItemsPerRegionStepper.maximumValue = Double(numItemsPerRegion.maximum)
        numItemsPerRegionStepper.value = Double(numItemsPerRegion.current)

        let itemSize = viewModel.itemSize
        itemSizeLabel.text = "\(Int(itemSize.current))"
        itemSizeSlider.minimumValue = Float(itemSize.minimum)
        itemSizeSlider.maximumValue = Float(itemSize.maximum)
        itemSizeSlider.value = Float(itemSize.current)

        let itemElasticity = viewModel.itemElasticity
        let nsNum = NSNumber(floatLiteral: Double(itemElasticity.current))
        itemElasticityLabel.text = ViewModel.itemElasticityNumberFormatter.string(from: nsNum)
        if let step = viewModel.itemElasticity.step { itemElasticitySlider.step = Float(step) }
        itemElasticitySlider.minimumValue = Float(itemElasticity.minimum)
        itemElasticitySlider.maximumValue = Float(itemElasticity.maximum)
        itemElasticitySlider.value = Float(itemElasticity.current)
    }

    @IBAction fileprivate func stepperValueChanged(_ sender: UIStepper)
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

    @IBAction fileprivate func sliderValueChanged(_ sender: UISlider)
    {
        switch sender
        {
        case itemSizeSlider:
            let itemSize = CGFloat(itemSizeSlider.value)
            itemSizeLabel.text = "\(Int(itemSize))"
            delegate?.itemSizeDidChangeTo(itemSize)
        case itemElasticitySlider:
            let itemElasticity: CGFloat
            let step = itemElasticitySlider.step
            if step > 0 { itemElasticity = CGFloat(step * Float(Int(itemElasticitySlider.value / step))) }
            else { itemElasticity = CGFloat(itemElasticitySlider.value) }
            let nsNum = NSNumber(floatLiteral: Double(itemElasticity))
            itemElasticityLabel.text = ViewModel.itemElasticityNumberFormatter.string(from: nsNum)
            delegate?.itemElasticityDidChangeTo(itemElasticity)
        default:
            fatalError("Unhandled sender in call to sliderValueChanged(:)")
            break
        }
    }

    @IBAction fileprivate func switchValueChanged(_ sender: UISwitch)
    {
        switch sender
        {
        case showAllRegionsSwitch:
            let showAllRegions = showAllRegionsSwitch.isOn
            delegate?.showAllRegionsDidChangeTo(showAllRegions)
        case showRefRegionSwitch:
            let showRefRegion = showRefRegionSwitch.isOn
            delegate?.showRefRegionDidChangeTo(showRefRegion)
        default:
            fatalError("Unhandled sender in call to switchValueChanged(:)")
            break
        }
    }
}
