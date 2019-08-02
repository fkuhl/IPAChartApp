//
//  KeyViewKind.swift
//  PlacingViews
//
//  Created by Frederick Kuhl on 10/5/16.
//  Copyright © 2016 TyndaleSoft LLC. All rights reserved.
//

import Foundation

enum KeyViewKind: String {
    case normal    = "normal"    //displays and adds one or more characters
    case diacritic = "diacritic" //displays dotted ring; for combining symbols
    case tie       = "tie"       //displays two dotted rings
    case blank     = "blank"     //blank placeholder; also h & w constraints
    case newView   = "newView"   //doesn't add a character, instead brings up new view
    case backspace = "backspace" //displays backspace character; causes backspace
}
