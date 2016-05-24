//
//  ControlView.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit

protocol ControlViewDelegate: class
{
    func controlView(controlView: ControlView, wantsToChangeModelTo model: KaleidoscopeModel)
    func controlViewNeedsViewCenterAndRadius(controlView: ControlView) -> (center: CGPoint, radius: CGFloat)
}

class ControlView: UIView
{
    weak var delegate: ControlViewDelegate?

    func updateWithModel(model: KaleidoscopeModel)
    {
        let numRegions = model.numRegions
        numRegionsLabel?.text = "\(numRegions)"
        numRegionsStepper?.value = Double(numRegions)

        let numItemsPerRegion = model.numItemsPerRegion
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
        if let (center, radius) = delegate?.controlViewNeedsViewCenterAndRadius(self)
        {
            let model = KaleidoscopeModel(numRegions: numRegions, numItemsPerRegion: numItemsPerRegion,
                                          center: center, radius: radius)
            updateWithModel(model)
            delegate?.controlView(self, wantsToChangeModelTo: model)
        }
    }
}
