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
    private let updateQueue = DispatchQueue(label: "com.tyndalesoft.ipaboard.chartvc", attributes: .concurrent)
    
    func updateDesign(to newSceneKind: SceneKind) {
        updateQueue.sync { doUpdate(newSceneKind) }
    }
    
    private func doUpdate(_ newSceneKind: SceneKind) {
        //This is happening with a rotation animation, so don't animate this change!
        //print("ChartVC \(self) updateDesign to \(newSceneKind); currentScene is \(String(describing: currentScene))")
        if newSceneKind == currentScene?.sceneKind { return }
        //print("Current thread \(Thread.current)")
        //print("ChartVC.updateDesign about to instantiate \(chartKind!.rawValue)")
        chartStoryboard = UIStoryboard(name: chartKind!.rawValue, bundle: nil)
        //No point in checking that the preceding call succeeded; it will throw a horrible exception if it doesn't.
        guard let newViewController = chartStoryboard?.instantiateViewController(withIdentifier: newSceneKind.sceneID) else {
            //Once again, if the preceding failed, there would be a horrible exception.
            return
        }
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        if let currentController = self.currentScene?.controller {
            currentController.willMove(toParent: nil)
            currentController.view.removeFromSuperview()
            currentController.removeFromParent()
        }
        self.addChild(newViewController)
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
        newViewController.didMove(toParent: self)
        self.initializeKey(self.view!)
        self.currentScene = (newSceneKind, newViewController)
        //print("currentScene set to \(String(describing: currentScene))")
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
            candidateKey.subviews.forEach{ initializeKey($0) }
        }
    }
    
}
