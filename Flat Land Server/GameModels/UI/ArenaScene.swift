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
	weak var arenaDelegate:ArenaDelegate?
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
		if event.characters == "p"{
			makeMyself(type: .triplet)
			return
		}
		switch event.characters {
		case "1":
			makeMyself(type: .destroyer)
			return
		case "2":
			makeMyself(type: .octatank)
			return
		default:
			break
		}
		guard let direction = CharForDirection[event.characters!]else{return}
		directions[direction] = true
		updateDirection()
	}
	
	func makeMyself(type:TankType){
		if let dummy = dummy, let arena = arenaDelegate{
			arena.removeEntity(entity: dummy as! GKEntity)
		}
		dummy = clickDelegate!.getControllable(tankType: type)
	}
}

extension ArenaModel{
	func getControllable(tankType:TankType)->Controllable{
		return getControllableEntity(tankType:tankType)
	}
}
protocol ArenaSceneTouchDelegate {
    func clicked(point:CGPoint) -> Void
    func makeAllTankGo(direction:Direction?)
	func getControllable(tankType:TankType)->Controllable
}
let CharForDirection:[String:Direction] = [
	"w":.UP,
	"a":.LEFT,
	"s":.DOWN,
	"d":.RIGHT,
]
let DirectionForImpulse:[Direction:CGVector] = [
    .UP     :CGVector(dx: 00, dy: 1),
    .DOWN   :CGVector(dx: 00, dy: -1),
    .RIGHT  :CGVector(dx: 1, dy: 00),
    .LEFT   :CGVector(dx: -1, dy: 00),
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
