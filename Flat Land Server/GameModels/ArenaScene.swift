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
    override func keyDown(with event: NSEvent) {
        if let char = event.characters{
            clickDelegate?.makeAllTankGo(direction: DirectionforKey[char])
        }
    }
    override func keyUp(with event: NSEvent) {
        clickDelegate?.makeAllTankGo(direction: nil)
    }
}
protocol ArenaSceneTouchDelegate {
    func clicked(point:CGPoint) -> Void
    func makeAllTankGo(direction:Direction?)
}
let DirectionForImpulse:[Direction:CGVector] = [
    .UP     :CGVector(dx: 00, dy: 400),
    .DOWN   :CGVector(dx: 00, dy: -400),
    .RIGHT  :CGVector(dx: 400, dy: 00),
    .LEFT   :CGVector(dx: -400, dy: 00),
]
let DirectionforKey:[String:Direction] = [
    "w":.UP,
    "a":.LEFT,
    "s":.DOWN,
    "d":.RIGHT,
]
enum Direction {
    case UP
    case DOWN
    case RIGHT
    case LEFT
}
