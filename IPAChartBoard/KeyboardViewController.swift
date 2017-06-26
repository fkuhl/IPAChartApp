//
//  KeyboardViewController.swift
//  IPAChartBoard
//
//  Created by Frederick Kuhl on 4/13/17.
//  Copyright © 2017 TyndaleSoft LLC. All rights reserved.
//
//user defaults:
//https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-userdefaults

import UIKit

class KeyboardViewController: UIInputViewController, KeyViewDelegate {
    
    @IBOutlet weak var content: UIView!
    var currentScene = Scene(chart: .consonants)
    var currentControllerIfAny: ChartViewController!
    private var chartsPopover: ChartsPopoverViewController?
    
    @IBAction func globeTapped(_ sender: UIButton) {
        self.advanceToNextInputMode()
    }
    
    @IBAction func heartTapped(_ sender: UIButton) {
        self.revealView(scene: Scene(chart: .favorites))
    }
    
    @IBAction func numbersTapped(_ sender: UIButton) {
        self.revealView(scene: Scene(chart: .numbers))
    }
    
    @IBAction func consonantsTapped(_ sender: UIButton) {
        self.revealView(scene: Scene(chart: .consonants))
        chartsPopover?.dismiss(animated: false) {
            self.chartsPopover = nil
        }
    }
    
    @IBAction func vowelsTapped(_ sender: UIButton) {
        self.revealView(scene: Scene(chart: .vowels))
        chartsPopover?.dismiss(animated: false) {
            self.chartsPopover = nil
        }
    }
    
    @IBAction func suprasegmentalsTapped(_ sender: UIButton) {
        self.revealView(scene: Scene(chart: .suprasegmentals))
        chartsPopover?.dismiss(animated: false) {
            self.chartsPopover = nil
        }
    }
    
    @IBAction func tonesTapped(_ sender: UIButton) {
        self.revealView(scene: Scene(chart: .tones))
        chartsPopover?.dismiss(animated: false) {
            self.chartsPopover = nil
        }
    }
    
    @IBAction func diacriticsTapped(_ sender: UIButton) {
        self.revealView(scene: Scene(chart: .diacritics))
        chartsPopover?.dismiss(animated: false) {
            self.chartsPopover = nil
        }
    }
    
    @IBAction func nonpulmonicTapped(_ sender: UIButton) {
        self.revealView(scene: Scene(chart: .nonpulmonics))
        chartsPopover?.dismiss(animated: false) {
            self.chartsPopover = nil
        }
    }
    
    @IBAction func otherTapped(_ sender: UIButton) {
        self.revealView(scene: Scene(chart: .other))
        chartsPopover?.dismiss(animated: false) {
            self.chartsPopover = nil
        }
    }
    
    @IBAction func spaceTapped(_ sender: UIButton) {
        addText(" ")
    }
    
    @IBAction func backspaceTapped(_ sender: UIButton) {
        self.textDocumentProxy.deleteBackward()
    }
    
    @IBAction func carriageReturnTapped(_ sender: UIButton) {
        self.addText("\n")
    }
    
    @IBAction func downArrowTapped(_ sender: UIButton) {
        self.dismissKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentControllerIfAny == nil {
            revealView(scene: currentScene)
            print("KeyboardVC.viewDidLoad on \(self), scene set to \(currentScene)")
        } else {
            print("KeyboardVC.viewDidLoad on \(self), scene already set to \(currentScene)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let favorites = FavoritesCache.sharedInstance
        favorites.readFromDefaults()
        print("KeyboardVC viewWillAppear got \(favorites.count) entries")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let favorites = FavoritesCache.sharedInstance
        favorites.writeToDefaults()
        print("KeyboardVC viewDidDisappear stored \(favorites.count) entries")
        //favorites.printEntries()
    }
    
    override func viewWillLayoutSubviews() {
        //Why I have to set these here is a mystery.
        let widthConstraint = content.widthAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.size.width)
        widthConstraint.identifier = "contentWidth"
        widthConstraint.priority = 500
        widthConstraint.isActive = true
        let heightConstraint = content.heightAnchor.constraint(greaterThanOrEqualToConstant: 184.0)
        heightConstraint.identifier = "contentHeight"
        heightConstraint.priority = 500
        heightConstraint.isActive = true
        //this gets called because of rotation or other change of size (not new further view)
        let currentSceneKind = currentScene.sceneKind
        var newSceneKind: SceneKind
        switch currentSceneKind {
        case .base, .regular, .compactWide, .compactNarrow:
            newSceneKind = sceneKindFor(trait: self.traitCollection.horizontalSizeClass, size: view.bounds.size)
        case .furtherNarrow(let id), .furtherWide(let id):
            newSceneKind = sceneKindFor(further: id, size: view.bounds.size)
        }
        print("KeyboardVC.viewWillLayoutSubviews to \(newSceneKind) for view size \(view.bounds.size)")
        currentControllerIfAny?.updateDesign(to: newSceneKind)
        currentScene = update(scene: currentScene, toKind: newSceneKind)
    }
    
    private func revealView(scene: Scene) {
        print("KeyboardVC.revealView of \(scene)")
        if scene == currentScene && currentControllerIfAny != nil { return }
        let storyboard = UIStoryboard(name: scene.chartKind.rawValue, bundle: nil)
        let storyboardID = scene.sceneKind.sceneID
        let newChartViewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
        newChartViewController.view.translatesAutoresizingMaskIntoConstraints = false
        if let newChart = newChartViewController as? ChartViewController {
            newChart.chartKind = scene.chartKind
            newChart.keyboardViewController = self
            //print("setting keybdVC in reveal of \(chart.rawValue)")
        }
        UIView.animate(withDuration: 0.25, animations: {
            if let currentChart = self.currentControllerIfAny {
                currentChart.willMove(toParentViewController: nil)
                currentChart.view.removeFromSuperview()
                currentChart.removeFromParentViewController()
            }
            self.addChildViewController(newChartViewController)
            self.content!.addSubview(newChartViewController.view)
            let topConstraint = self.content!.topAnchor.constraint(equalTo: newChartViewController.view.topAnchor)
            topConstraint.isActive = true
            let bottomConstraint = self.content!.bottomAnchor.constraint(equalTo: newChartViewController.view.bottomAnchor)
            bottomConstraint.isActive = true
            let leadingConstraint = self.content!.leadingAnchor.constraint(equalTo: newChartViewController.view.leadingAnchor)
            leadingConstraint.isActive = true
            let trailingConstraint = self.content!.trailingAnchor.constraint(equalTo: newChartViewController.view.trailingAnchor)
            trailingConstraint.isActive = true
        },
                       completion: { _ in
                        newChartViewController.didMove(toParentViewController: self)
                        if let newChart = newChartViewController as? ChartViewController {
                            var sceneAfterAdjustment = scene
                            if scene.sceneKind == .base {
                                //never a 'further' at this point
                                let newSceneKind = sceneKindFor(trait: self.traitCollection.horizontalSizeClass, size: self.view.bounds.size)
                                sceneAfterAdjustment = Scene(chart: scene.chartKind, scene: newSceneKind)
                                newChart.updateDesign(to: newSceneKind)
                            }
                            self.currentScene = sceneAfterAdjustment
                            self.currentControllerIfAny = newChart
                        }
                        self.initializeKey(self.view!)
        })
    }
    
    //a little recursion through all the subviews
    private func initializeKey(_ candidateKey: UIView) {
        if let keyView = candidateKey as? KeyView {
            keyView.initialize(withController: self)
        } else {
            for subView in candidateKey.subviews {
                initializeKey(subView)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing seque \(String(describing: segue.identifier))")
        if segue.identifier != "Chart Popover" { return }
        chartsPopover = segue.destination as? ChartsPopoverViewController
        chartsPopover?.keyboardViewController = self
    }
    
    
    
    //MARK: KeyViewDelegate
    
    
    func keyTapped(textToAdd: String, keyKind: KeyViewKind, scalars: String) {
        addText(textToAdd)
        let favorites = FavoritesCache.sharedInstance
        //print("fav: \(favorites.stamp)")
        if let currentCount = favorites[keyKind, scalars] {
            favorites[keyKind, scalars] = currentCount + 1
        } else {
            favorites[keyKind, scalars] = 1
        }
        //print("after key tapped, \(favorites.count) entries in \(favorites.stamp)")
    }
    
    private func addText(_ addition: String) {
        self.textDocumentProxy.insertText(addition)
    }
    
    func changeScene(to newSceneID: String) {
        let newScene = Scene(chart: currentScene.chartKind,
                             scene: sceneKindFor(further: newSceneID, size: view.bounds.size))
        currentControllerIfAny?.updateDesign(to: newScene.sceneKind)
        currentScene = newScene //controller doesn't change
    }
    
    func backspaceTapped() {
        self.textDocumentProxy.deleteBackward()
    }
    
    
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        /*
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
 */
    }

}
