//
//  KeyViewDelegate.swift
//  Designable
//
//  Created by Frederick Kuhl on 9/26/16.
//  Copyright © 2016 TyndaleSoft LLC. All rights reserved.
//

import UIKit

//When KeyView is tapped, this is where the glyph is sent

protocol KeyViewDelegate {
    func keyTapped(textToAdd: String, keyKind: KeyViewKind, scalars: String)
    func changeScene(to: String)
    func backspaceTapped()
}
