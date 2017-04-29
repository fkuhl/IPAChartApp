//
//  SceneKind.swift
//  DevelopKeyboard
//
//  Created by Frederick Kuhl on 11/25/16.
//  Copyright © 2016 TyndaleSoft LLC. All rights reserved.
//

import UIKit

enum SceneKind {
    case base
    case regular
    case compactWide
    case compactNarrow
    case furtherWide(String)
    case furtherNarrow(String)
    
    var sceneID: String {
        get {
            switch self {
            case .base: return "base"
            case .regular: return "regular"
            case .compactWide: return "compactWide"
            case .compactNarrow: return "compactNarrow"
            case .furtherWide(let id): return id + "Wide"
            case .furtherNarrow(let id): return id + "Narrow"
            }
        }
    }
}

func sceneKindFor(trait: UIUserInterfaceSizeClass, size: CGSize) -> SceneKind {
    switch trait {
    case .regular, .unspecified:
        return .regular
    case .compact:
        if isWide(size: size) {
            return .compactWide
        } else {
            return .compactNarrow
        }
    }
}

func sceneKindFor(further: String, size: CGSize) -> SceneKind {
    if isWide(size: size) {
        return .furtherWide(further)
    } else {
        return .furtherNarrow(further)
    }
}

private func isWide(size: CGSize) -> Bool {
    return size.width >= size.height * 1.5
}
