//
//  OverlayManager.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/15/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class OverlayManager{
    let scene:SKScene
    let label:SKLabelNode
    init(scene:SKScene) {
        self.scene = scene
        label = SKLabelNode(text: "hello!")
        label.fontColor = NSColor.black
        label.position = CGPoint(x: scene.size.width/2, y: label.fontSize*1.5)
        scene.addChild(label)
    }
    func set(_ announcement:String) {
        label.text = announcement
    }
}
