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
	var rotation:CGFloat = 0
	init(tank:Tank=getTank(type: .twin), position: CGPoint, scene: SceneComponentDelegate?, turretDelegate:TurretDelegate, map:MapComponentDelegate, arena:ArenaDelegate) {
        self.turretDelegate = turretDelegate
        self.arena = arena
        self.tank = tank//getTank(type: .twin)
        super.init()
		for i in tank.turrets{
			turrets.append(TurretEntity(turret: i, tankEntity: self))
		}
		self.addComponent(TurretComponent(turretDelegate: turretDelegate, map: map))
        self.addComponent(SpriteComponent(tankEntity: self, scene: scene))
        self.addComponent(PhysicsComponent(tank:self.tank))
        self.addComponent(HealthComponent(arenaDelegate: arena))
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
		if let position = node?.position{
			self.rotation = CGPoint.getAngle(rotatePoint-position)
		}
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
	weak var tankEntity:ShapeTankEntity?
	lazy var turretLength = {
		return turret.turretSize.width * self.tankEntity!.tank.size
	}()
	init(turret:Turret, tankEntity:ShapeTankEntity) {
		self.turret = turret
		self.tankEntity = tankEntity
	}
	func getTurretRect() -> CGRect{
		let tank = tankEntity!.tank
		let width = turret.turretSize.width * tank.size
		let height = turret.turretSize.height * tank.size
		return CGRect(x: 0, y: -height/2.0, width: width, height: height)
	}
	func getTurretPosition() -> CGPoint{
		let tank = tankEntity!.tank
		return turret.position * tank.size
	}
}

@objc protocol Controllable {
    @objc optional func move(_ direction:CGVector)
    @objc optional func fire(_ fire:Bool)
    @objc optional func rotateTo(_ point:CGPoint)
}
