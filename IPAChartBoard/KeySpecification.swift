//
//  KeySpecification.swift
//  DevelopKeyboard
//
//  Created by Frederick Kuhl on 3/15/17.
//  Copyright © 2017 TyndaleSoft LLC. All rights reserved.
//

/*
 Turns out this can't be used for a prop list.
 But it's useful example code.
 */

import Foundation

struct KeySpecification: Hashable {
    let scalars: String
    let kind:    String  //see KeyViewKind
    
    init(scalars theScalars: String, kind theKind: String) {
        scalars = theScalars
        kind = theKind
    }
    
    var hashValue: Int {
        return scalars.hashValue ^ kind.hashValue
    }
}

func == (left: KeySpecification, right: KeySpecification) -> Bool {
    return left.scalars == right.scalars && left.kind == right.kind
}
