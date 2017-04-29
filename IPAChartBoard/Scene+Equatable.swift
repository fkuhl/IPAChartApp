//
//  Scene+Equatable.swift
//  DevelopKeyboard
//
//  Created by Frederick Kuhl on 11/25/16.
//  Copyright © 2016 TyndaleSoft LLC. All rights reserved.
//

import Foundation

extension Scene: Equatable { }

func == (left: Scene, right: Scene) -> Bool {
    return left.chartKind == right.chartKind && left.sceneKind == right.sceneKind
}
