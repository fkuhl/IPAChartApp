//
//  ChartViewController.swift
//  DevelopKeyboard
//
//  Created by Frederick Kuhl on 10/31/16.
//  Copyright © 2016 TyndaleSoft LLC. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController  {
    var keyboardViewController: KeyboardViewController?
    private var chartStoryboard: UIStoryboard?
    var chartKind: ChartKind?
    private var keysHaveBeenWired = false
    private var currentScene: (sceneKind: SceneKind, controller: UIViewController)? = nil
    
    func updateDesign(to newSceneKind: SceneKind) {
        //This is happening with a rotation animation, so don't animate this change!
        print("ChartVC.updateDesign to \(newSceneKind)")
        if newSceneKind == currentScene?.sceneKind { return }
        chartStoryboard = UIStoryboard(name: chartKind!.rawValue, bundle: nil)
        //No point in checking that the preceding call succeeded; it will throw a horrible exception if it doesn't.
        guard let newViewController = chartStoryboard?.instantiateViewController(withIdentifier: newSceneKind.sceneID) else {
            //Once again, if the preceding failed, there would be a horrible exception.
            return
        }
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        if let currentController = self.currentScene?.controller {
            currentController.willMove(toParentViewController: nil)
            currentController.view.removeFromSuperview()
            currentController.removeFromParentViewController()
        }
        self.addChildViewController(newViewController)
        self.view!.addSubview(newViewController.view)
        let topConstraint = self.view!.topAnchor.constraint(equalTo: newViewController.view.topAnchor)
        topConstraint.isActive = true
        let bottomConstraint = self.view!.bottomAnchor.constraint(equalTo: newViewController.view.bottomAnchor)
        bottomConstraint.isActive = true
        let leadingConstraint = self.view!.leadingAnchor.constraint(equalTo: newViewController.view.leadingAnchor)
        leadingConstraint.isActive = true
        let trailingConstraint = self.view!.trailingAnchor.constraint(equalTo: newViewController.view.trailingAnchor)
        trailingConstraint.isActive = true
        newViewController.view.setNeedsLayout()
        newViewController.view.setNeedsDisplay()
        newViewController.didMove(toParentViewController: self)
        self.currentScene = (newSceneKind, newViewController)
        self.initializeKey(self.view!)
    }
    
    /*
     Strategy: viewWillAppear is called late, after all the VCs are embedded, and the whole view hierarchy
     is complete. But viewWillAppear may be called multiple times, so we avoid unecessary initializations.
     Because the view hierarchy is complete when this is called, the one call to initializeKey does it all.
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !keysHaveBeenWired {
            initializeKey(self.view)
            keysHaveBeenWired = true
        }
    }
    
    //a little recursion through all the subviews
    //performed late, but early enough to have constraints in place
    private func initializeKey(_ candidateKey: UIView) {
        if let keyView = candidateKey as? KeyView {
            keyView.initialize(withController: self.keyboardViewController!)
        } else {
            for subView in candidateKey.subviews {
                initializeKey(subView)
            }
        }
    }
    
}
