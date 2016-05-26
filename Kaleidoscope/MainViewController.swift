//
//  MainViewController.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


class MainViewController: UIViewController
{
    @IBOutlet private weak var kaleidoscopeView: KaleidoscopeView!

    private var controlsViewController: ControlsViewController! {
        didSet { controlsViewController?.delegate = self }
    }

    private var kaleidoscopeEngine: KaleidoscopeEngine! {
        didSet { kaleidoscopeEngine?.delegate = self }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialiseKaleidoscopeEngine()
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        initialiseControls()
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        updateKaleidoscopeEngineGeometry()
        kaleidoscopeEngine?.start()
    }

    override func viewWillDisappear(animated: Bool)
    {
        kaleidoscopeEngine?.stop()
        super.viewWillDisappear(animated)
    }
}


extension MainViewController
{
    private func initialiseKaleidoscopeEngine()
    {
        kaleidoscopeEngine = KaleidoscopeEngine()

        // Configure initial engine values here, if desired.
    }

    private func initialiseControls()
    {
        guard kaleidoscopeEngine != nil else { fatalError("MainViewController: kaleidoscopeEngine not set") }
        guard controlsViewController != nil else { fatalError("MainViewController: controlsViewController not set") }
        
        let numRegions = kaleidoscopeEngine.configuration.numRegions
        let numItemsPerRegion = kaleidoscopeEngine.configuration.numItemsPerRegion
        let itemSize = kaleidoscopeEngine.configuration.itemSize
        let itemElasticity = kaleidoscopeEngine.configuration.itemElasticity

        let controlsViewModel = ControlsViewController.ViewModel(
            showRegions: false,
            numRegions: ValueInRange<Int>(min: 1, max: 20, cur: numRegions),
            numItemsPerRegion: ValueInRange<Int>(min: 1, max: 25, cur: numItemsPerRegion),
            itemSize: ValueInRange<CGFloat>(min: 5, max: 25, cur: itemSize),
            itemElasticity: ValueInRange<CGFloat>(min: 0.9, max: 1.1, cur: itemElasticity)
        )
        controlsViewController.viewModel = controlsViewModel
    }

    private func updateKaleidoscopeEngineGeometry()
    {
        guard kaleidoscopeView != nil else { fatalError("MainViewController: kaleidoscopeView not set") }
        guard kaleidoscopeEngine != nil else { fatalError("MainViewController: kaleidoscopeEngine not set") }

        let viewCenter = kaleidoscopeView.viewCenter
        kaleidoscopeEngine.worldCenter = viewCenter

        let viewRadius = kaleidoscopeView.viewRadius
        kaleidoscopeEngine.worldRadius = viewRadius
    }
}


extension MainViewController: SegueIdentifierAware
{
    enum SegueIdentifier: String
    {
        case EmbedControls
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let segueID = segueIdentifierForSegue(segue)
        switch segueID
        {
        case .EmbedControls:
            if let controlsViewController = segue.destinationViewController as? ControlsViewController
            { self.controlsViewController = controlsViewController }
            else { fatalError("invalid destination view controller for segue identifier '\(segueID)'") }
        }
    }
}


extension MainViewController: ControlsViewControllerDelegate
{
    func showRegionsDidChangeTo(showRegions: Bool)
    { kaleidoscopeView?.setNeedsDisplay() }

    func numRegionsDidChangeTo(numRegions: Int)
    { kaleidoscopeEngine?.configuration.numRegions = numRegions }

    func numItemsPerRegionsDidChangeTo(numItemsPerRegion: Int)
    { kaleidoscopeEngine?.configuration.numItemsPerRegion = numItemsPerRegion }

    func itemSizeDidChangeTo(itemSize: CGFloat)
    { kaleidoscopeEngine?.configuration.itemSize = itemSize }

    func itemElasticityDidChangeTo(itemElasticity: CGFloat)
    { kaleidoscopeEngine?.configuration.itemElasticity = itemElasticity }
}


extension MainViewController: KaleidoscopeEngineDelegate
{
    func kaleidoscopeEngineDidUpdateState()
    { kaleidoscopeView?.setNeedsDisplay() }
}
