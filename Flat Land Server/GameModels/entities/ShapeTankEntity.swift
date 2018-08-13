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
    var direction:Direction?
	var rotatePoint:CGPoint = .zero
    init(type:EntityType, position: CGPoint, scene: SceneComponentDelegate?, turretDelegate:TurretDelegate, map:MapComponentDelegate, arena:ArenaDelegate) {
        self.turretDelegate = turretDelegate
        self.arena = arena
        self.tank = getTank(type: .twin)
        super.init()
		self.addComponent(TurretComponent(tank:tank,turretDelegate: turretDelegate, map: map))
        self.addComponent(SpriteComponent.init(tank: tank, scene: scene))
        self.addComponent(PhysicsComponent(tank:self.tank))
        //self.addComponent(AgentComponent())
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

@objc protocol Controllable {
    @objc optional func move(_ direction:CGVector)
    @objc optional func fire(_ fire:Bool)
    @objc optional func rotateTo(_ point:CGPoint)
}
