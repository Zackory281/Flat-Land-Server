//
//  ArenaScene.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 6/20/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Cocoa
import GameplayKit

class ArenaScene: SKScene {
    var clickDelegate:ArenaSceneTouchDelegate?
    override func mouseDown(with event: NSEvent) {
        clickDelegate?.clicked(point: event.location(in: self))
    }
}
protocol ArenaSceneTouchDelegate {
    func clicked(point:CGPoint) -> Void
}
