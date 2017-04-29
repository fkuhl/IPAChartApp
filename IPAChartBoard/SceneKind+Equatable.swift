//
//  SceneKind+Equatable.swift
//  DevelopKeyboard
//
//  Created by Frederick Kuhl on 11/25/16.
//  Copyright © 2016 TyndaleSoft LLC. All rights reserved.
//

import Foundation

extension SceneKind: Equatable { }

func == (left: SceneKind, right: SceneKind) -> Bool {
    return left.sceneID == right.sceneID
}
