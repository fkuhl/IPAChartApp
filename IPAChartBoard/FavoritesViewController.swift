//
//  FavoritesViewController.swift
//  DevelopKeyboard
//
//  Created by Frederick Kuhl on 3/16/17.
//  Copyright © 2017 TyndaleSoft LLC. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    private static let interRowSpacing = CGFloat(4)
    private static let interKeySpacing = CGFloat(4)
    private static let topMargin = CGFloat(8)
    private static let bottomMargin = topMargin
    private static let leadingMargin = CGFloat(20)
    private static let trailingMargin = leadingMargin
    private static let dummyFrame = CGRect(x: 0, y: 0, width: 10, height: 10)
    private var kv: KeyView?
    private var leftStack, rightStack, topStack, bottomStack: NSLayoutConstraint?
    private var sortedFavorites: [(key: String, value: Int)]?
    //SceneKind: regular, compactWide, compactNarrow must be set in storyboard!
    @IBInspectable var kind: String = ""

    /*
     The favorite buttons are created and constrained in viewDidLoad, because the buttons
     don't appear if made in any other callback. (See below.) But in vDL bounds haven't been
     set, so we can't compute the layout from the view size. Instead we set an arbitrary
     layout based on "scene kind", which is set as an attribute in the storyboard.
    */
    
    override func viewDidLoad() {
        view.translatesAutoresizingMaskIntoConstraints = false //not sure this is needed here
        //self.view.backgroundColor = UIColor.lightGray  //we've changed to default
        let favorites = FavoritesCache.sharedInstance
        if favorites.count == 0 { return }
        sortedFavorites = favorites.getSorted()
//        for (key, value) in sortedFavorites! {
//            print("key \(key) occurred \(value) times")
//        }
        var layout: (rows: Int, columns: Int)
        switch kind {
        case "regular":
            layout = (4, 9)
        case "compactWide":
            layout = (4, 9)
        case "compactNarrow":
            layout = (4, 6)
        default:
            preconditionFailure("FVC.vdl: unrecognized kind \(kind)")
        }
        //view.translatesAutoresizingMaskIntoConstraints = false //not sure this is needed here
        createStackOfRows(for: layout.rows, columns: layout.columns)
        view.setNeedsLayout()
        view.setNeedsDisplay()
    }
    
    //viewDidLoad doesn't have bounds set, but displays keys
    //viewWillAppear ditto
    //viewWillTransition(to:with:) isn't called on first presentation (no transition?), then has wrong size, and doesn't display keys
    //viewWillLayoutSubviews has correct size, but doesn't display keys!
    //viewDidLayoutSubviews ditto
    
    private func createStackOfRows(for rows: Int, columns: Int) {
        let stackOfRows = UIStackView()
        self.view.addSubview(stackOfRows)
        stackOfRows.translatesAutoresizingMaskIntoConstraints = false
        stackOfRows.alignment = .leading
        stackOfRows.axis = .vertical
        stackOfRows.distribution = .fill
        stackOfRows.spacing = FavoritesViewController.interRowSpacing
        //Stacks need just 2 constraints (e.g., left and top), and natural size determines the rest.
        leftStack = stackOfRows.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: FavoritesViewController.leadingMargin)
        leftStack!.identifier = "leftStack"
        leftStack!.isActive = true
        topStack = stackOfRows.topAnchor.constraint(equalTo: self.view.topAnchor, constant: FavoritesViewController.topMargin)
        topStack!.identifier = "topStack"
        topStack!.isActive = true
        let lastIndexToDisplay = min(sortedFavorites!.count - 1, columns * rows - 1)
        var firstIndex = 0
        while firstIndex <= lastIndexToDisplay {
            let lastIndex = min(lastIndexToDisplay, firstIndex + columns - 1)
            addKeyRow(toStack: stackOfRows, firstIndex: firstIndex, lastIndex: lastIndex)
            firstIndex = firstIndex + columns
        }
   }
    
    private func addKeyRow(toStack stackOfRows: UIStackView, firstIndex: Int, lastIndex: Int) {
        let rowStack = UIStackView()
        stackOfRows.addArrangedSubview(rowStack)
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        rowStack.alignment = .top
        rowStack.axis = .horizontal
        rowStack.distribution = .equalSpacing
        rowStack.spacing = FavoritesViewController.interKeySpacing
        leftStack = rowStack.leftAnchor.constraint(equalTo: stackOfRows.leftAnchor)
        leftStack!.identifier = "\(firstIndex) leftStack"
        leftStack!.isActive = true
        //no right constraint means row stack can collapse left to its natural width
        for i in firstIndex...lastIndex {
            let keyView = KeyView(frame: FavoritesViewController.dummyFrame)
            let parsedKey = parseKeyViewKey(sortedFavorites![i].key)
                //TODO except tie and diacritic need h & w set too!
            keyView.kindAdapter = parsedKey.kind.rawValue
            keyView.unicodeScalar = parsedKey.scalars
            keyView.setOwnConstraints = true //coerce all key to set h&w constraints
            rowStack.addArrangedSubview(keyView)
        }
    }
}
