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
	weak var dummy:Controllable?
	var directions:[Direction:Bool] = [.UP:false,.RIGHT:false,.DOWN:false,.LEFT:false]
    override func mouseDown(with event: NSEvent) {
        clickDelegate?.clicked(point: event.location(in: self))
		dummy?.fire!(true)
    }
	func updateDirection(){
		guard let dummy = dummy else {
			print("dummy not set"); return
		}
		var velocity = CGVector.zero
		for direction in directions where direction.value{
			velocity = velocity + DirectionForImpulse[direction.key]!
		}
		dummy.move?(velocity)
	}
	
	override func mouseMoved(with event: NSEvent) {
		//print(event.location(in: self))
		dummy?.rotateTo!(event.location(in: self))
	}
    override func keyUp(with event: NSEvent) {
		guard let direction = CharForDirection[event.characters!]else{return}
		directions[direction] = false
		updateDirection()
    }
	override func keyDown(with event: NSEvent) {
		if event.characters == "p", dummy == nil{
			dummy = clickDelegate!.getControllable()
		}
		guard let direction = CharForDirection[event.characters!]else{return}
		directions[direction] = true
		updateDirection()
	}
}

extension ArenaModel{
	func getControllable()->Controllable{
		return getControllableEntity()
	}
}
protocol ArenaSceneTouchDelegate {
    func clicked(point:CGPoint) -> Void
    func makeAllTankGo(direction:Direction?)
	func getControllable()->Controllable
}
let CharForDirection:[String:Direction] = [
	"w":.UP,
	"a":.LEFT,
	"s":.DOWN,
	"d":.RIGHT,
]
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
