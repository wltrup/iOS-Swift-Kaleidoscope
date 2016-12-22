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
    @IBOutlet fileprivate weak var kaleidoscopeView: KaleidoscopeView!

    fileprivate var controlsViewController: ControlsViewController! {
        didSet { controlsViewController?.delegate = self }
    }

    fileprivate var kaleidoscopeEngine: KaleidoscopeEngine! {
        didSet { kaleidoscopeEngine?.delegate = self }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialiseKaleidoscopeEngine()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        initialiseViews()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        updateKaleidoscopeEngineGeometry()
        kaleidoscopeEngine?.start()
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        kaleidoscopeEngine?.stop()
        super.viewWillDisappear(animated)
    }

    override func viewWillTransition(to size: CGSize,
                                           with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animate(alongsideTransition: {_ in})
        {
            [weak self] _ in
            if let myself = self { myself.updateKaleidoscopeEngineGeometry() }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }

}


extension MainViewController: SegueIdentifierAware
{
    enum SegueIdentifier: String
    {
        case EmbedControls
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let segueID = segueIdentifierForSegue(segue)
        switch segueID
        {
        case .EmbedControls:
            if let controlsViewController = segue.destination as? ControlsViewController
            { self.controlsViewController = controlsViewController }
            else { fatalError("invalid destination view controller for segue identifier '\(segueID)'") }
        }
    }
}


extension MainViewController: ControlsViewControllerDelegate
{
    func showAllRegionsDidChangeTo(_ showAllRegions: Bool)
    { kaleidoscopeView?.showAllRegions = showAllRegions }

    func showRefRegionDidChangeTo(_ showRefRegion: Bool)
    { kaleidoscopeView?.showRefRegion = showRefRegion }

    func numRegionsDidChangeTo(_ numRegions: Int)
    {
        kaleidoscopeEngine?.configuration.numRegions.current = numRegions
        updateKaleidoscopeViewForChangeInNumRegions()
    }

    func numItemsPerRegionsDidChangeTo(_ numItemsPerRegion: Int)
    { kaleidoscopeEngine?.configuration.numItemsPerRegion.current = numItemsPerRegion }

    func itemSizeDidChangeTo(_ itemSize: CGFloat)
    { kaleidoscopeEngine?.configuration.itemSize.current = itemSize }

    func itemElasticityDidChangeTo(_ itemElasticity: CGFloat)
    { kaleidoscopeEngine?.configuration.itemElasticity.current = itemElasticity }
}


extension MainViewController: KaleidoscopeEngineDelegate
{
    func kaleidoscopeEngineDidUpdateState()
    { kaleidoscopeView?.items = kaleidoscopeEngine!.items }
}


extension MainViewController
{
    fileprivate func initialiseKaleidoscopeEngine()
    {
        kaleidoscopeEngine = KaleidoscopeEngine()

        // Configure initial engine values here, if different from default values.
    }

    fileprivate func initialiseViews()
    {
        guard kaleidoscopeEngine != nil else { fatalError("MainViewController: kaleidoscopeEngine not set") }
        guard kaleidoscopeView != nil else { fatalError("MainViewController: kaleidoscopeView not set") }
        guard controlsViewController != nil else { fatalError("MainViewController: controlsViewController not set") }

        kaleidoscopeView.showAllRegions = true
        kaleidoscopeView.showRefRegion = false
        updateKaleidoscopeViewForChangeInNumRegions()

        let engineConfiguration = kaleidoscopeEngine.configuration
        let controlsViewModel = ControlsViewController.ViewModel(
            showAllRegions: kaleidoscopeView.showAllRegions,
            showRefRegion: kaleidoscopeView.showRefRegion,
            numRegions: engineConfiguration.numRegions,
            numItemsPerRegion: engineConfiguration.numItemsPerRegion,
            itemSize: engineConfiguration.itemSize,
            itemElasticity: engineConfiguration.itemElasticity
        )
        controlsViewController.viewModel = controlsViewModel
    }

    fileprivate func updateKaleidoscopeEngineGeometry()
    {
        guard kaleidoscopeEngine != nil else { fatalError("MainViewController: kaleidoscopeEngine not set") }

        let viewCenter = kaleidoscopeView.viewCenter
        kaleidoscopeEngine.worldCenter = viewCenter

        let viewRadius = kaleidoscopeView.viewRadius
        kaleidoscopeEngine.worldRadius = viewRadius

        let interfaceOrientation = UIApplication.shared.statusBarOrientation
        kaleidoscopeEngine.configuration.interfaceOrientation = interfaceOrientation

        kaleidoscopeView.regionBoundaryPath = kaleidoscopeEngine.regionBoundaryPath()
    }

    fileprivate func updateKaleidoscopeViewForChangeInNumRegions()
    {
        let engineConfiguration = kaleidoscopeEngine.configuration
        kaleidoscopeView.numRegions = engineConfiguration.numRegions.current
        kaleidoscopeView.regionAngle = engineConfiguration.regionAngle

        kaleidoscopeView.regionBoundaryPath = kaleidoscopeEngine.regionBoundaryPath()
    }
}
