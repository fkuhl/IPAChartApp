//
//  Scene.swift
//  DevelopKeyboard
//
//  Created by Frederick Kuhl on 11/25/16.
//  Copyright © 2016 TyndaleSoft LLC. All rights reserved.
//

import Foundation

struct Scene {
    let chartKind: ChartKind
    let sceneKind: SceneKind
    
    init(chart: ChartKind, scene: SceneKind) {
        chartKind = chart
        sceneKind = scene
    }
    
    init(chart: ChartKind) {
        chartKind = chart
        sceneKind = .base
    }
    
}

func update(scene: Scene, toKind: SceneKind) -> Scene {
    return Scene(chart: scene.chartKind, scene: toKind)
}
