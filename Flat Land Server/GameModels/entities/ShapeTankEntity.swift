//
//  ShapeTankEntity.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/16/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class ShapeTankEntity:GKEntity, Controllable {
    var tank:Tank
	var turrets:[TurretEntity] = []
    var direction:Direction?
	var rotatePoint:CGPoint = .zero
	var node:SKNode?
	init(tank:Tank=getTank(type: .twin), position: CGPoint, scene: SceneComponentDelegate?, turretDelegate:TurretDelegate, map:MapComponentDelegate, arena:ArenaDelegate) {
        self.turretDelegate = turretDelegate
        self.arena = arena
        self.tank = tank//getTank(type: .twin)
		self.turrets.append(contentsOf: tank.turrets.map({ turret in
			return TurretEntity(turret: turret)
		}))
        super.init()
		self.addComponent(TurretComponent(tank:tank,turretDelegate: turretDelegate, map: map))
        self.addComponent(SpriteComponent(tankEntity: self, scene: scene))
        self.addComponent(PhysicsComponent(tank:self.tank))
        self.addComponent(HealthComponent())
        self.addComponent(DisappearComponent(function: disappearingFunction, arena: arena))
		self.spriteComponent.spriteNode.position = position
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var turretDelegate:TurretDelegate
    var arena:ArenaDelegate
    var turretComponent:TurretComponent{ return self.component(ofType: TurretComponent.self)! }
    var spriteComponent:SpriteComponent{ return self.component(ofType: SpriteComponent.self)! }
    var healthComponent:HealthComponent{ return self.component(ofType: HealthComponent.self)! }
    var agentComponent:AgentComponent{ return self.component(ofType: AgentComponent.self)! }
    var physicsComponent:PhysicsComponent{ return self.component(ofType: PhysicsComponent.self)! }
    let disappearingFunction:DisappearFunction = { (entity:GKEntity)->Bool in
        return entity.component(ofType: HealthComponent.self)?.isDead() ?? true
    }
	
	override func update(deltaTime seconds: TimeInterval) {
		self.tank.rotation = CGPoint.getAngle(rotatePoint-tank.tankNode!.position)
	}
	func rotateTo(_ point: CGPoint) {
		self.rotatePoint = point
	}
	func fire(_ fire:Bool){
		self.turretComponent.fireQueue+=1
	}
    func move(_ direction: CGVector) {
        self.physicsComponent.forceDirection = direction
    }
}

class TurretEntity{
	var turret:Turret
	var node:SKNode?
	var tank:Tank
	init(turret:Turret) {
		self.turret = turret
	}
	func getTurretRect() -> CGRect{
		let width = turret.turretSize.width * tank.size
		let height = turret.turretSize.height * tank.size
		return CGRect(x: 0, y: -height/2.0, width: width, height: height)
	}
	
	func getTurretPosition() -> CGPoint{
		return turret.position * tank.size
	}
}

@objc protocol Controllable {
    @objc optional func move(_ direction:CGVector)
    @objc optional func fire(_ fire:Bool)
    @objc optional func rotateTo(_ point:CGPoint)
}
