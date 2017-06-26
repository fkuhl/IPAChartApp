//
//  ChartsPopupViewController.swift
//  IPAChartApp
//
//  Created by Frederick Kuhl on 6/26/17.
//  Copyright © 2017 TyndaleSoft LLC. All rights reserved.
//

import UIKit

class ChartsPopoverViewController: UIViewController {
    weak var keyboardViewController: KeyboardViewController?
    
    
    @IBAction func consonantsTapped(_ sender: UIButton) {
        keyboardViewController?.consonantsTapped(sender)
    }
    
    @IBAction func vowelsTapped(_ sender: UIButton) {
        keyboardViewController?.vowelsTapped(sender)
    }
    
    @IBAction func suprasegmentalsTapped(_ sender: UIButton) {
        keyboardViewController?.suprasegmentalsTapped(sender)
    }
    
    @IBAction func tonesTapped(_ sender: UIButton) {
        keyboardViewController?.tonesTapped(sender)
    }
    
    @IBAction func diacriticsTapped(_ sender: UIButton) {
        keyboardViewController?.diacriticsTapped(sender)
    }
    
    @IBAction func nonpulmonicTapped(_ sender: UIButton) {
        keyboardViewController?.nonpulmonicTapped(sender)
    }
    
    @IBAction func otherTapped(_ sender: UIButton) {
        keyboardViewController?.otherTapped(sender)
    }
    
}
