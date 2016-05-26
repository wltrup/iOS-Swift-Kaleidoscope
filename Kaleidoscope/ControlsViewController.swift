//
//  ControlsViewController.swift
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
    var viewModel: ViewModel!

    struct ViewModel
    {
        let showRegions:       Bool
        let numRegions:        ValueInRange<Int>
        let numItemsPerRegion: ValueInRange<Int>
        let itemSize:          ValueInRange<CGFloat>
        let itemElasticity:    ValueInRange<CGFloat>
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        updateUI()
    }

    private static var itemElasticityNumberFormatter: NSNumberFormatter
    {
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
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
        guard viewModel != nil else { fatalError("ControlsViewController view model not set") }

        let showRegions = viewModel.showRegions
        showRegionsSwitch.on = showRegions

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
        itemElasticityLabel.text =
            ControlsViewController.itemElasticityNumberFormatter.stringFromNumber(itemElasticity.cur)
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
            itemElasticityLabel.text =
                ControlsViewController.itemElasticityNumberFormatter.stringFromNumber(itemElasticity)
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
