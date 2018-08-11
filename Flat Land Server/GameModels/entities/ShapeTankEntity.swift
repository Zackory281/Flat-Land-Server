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
    var tank:TankEntity
    var direction:Direction?
	var rotatePoint:CGPoint?
    init(type:EntityType, position: CGPoint, scene: SceneComponentDelegate?, turretDelegate:TurretDelegate, map:MapComponentDelegate, arena:ArenaDelegate) {
        self.turretDelegate = turretDelegate
        self.arena = arena
        self.tank = TankEntity(type: type,turret:[
            Turret(position: CGPoint(x: 0, y: 0.25), rotation: 0, size: CGSize(width: 1, height: 0.40)),
            Turret(position: CGPoint(x: 0, y: -0.25), rotation: 0, size: CGSize(width: 1, height: 0.40)),
            ], startingPosition: position, size: CGSize(width: 50, height: 50))
        super.init()
		self.addComponent(TurretComponent(tank:tank,turretDelegate: turretDelegate, map: map))
        self.addComponent(SpriteComponent.init(tank: tank, scene: scene))
        self.addComponent(PhysicsComponent(tank:self.tank))
        //self.addComponent(AgentComponent())
        self.addComponent(HealthComponent())
        self.addComponent(DisappearComponent(function: disappearingFunction, arena: arena))
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
	
	
	func rotateTo(_ point: CGPoint) {
		self.tank.rotation = CGPoint.getAngle(point-tank.tankNode!.position)
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

class TankEntity {
    var size:CGSize
	var rotation:CGFloat = 0
    var tankType:EntityType
    var texture:SKTexture
    var startingPosition:CGPoint
    var turrets:[Turret] = []
	var tankNode:SKNode?
    let physicsBodyCategory = BodyCategory.Entity
    init(type:EntityType, turret:[Turret]=[Turret()], startingPosition:CGPoint = CGPoint.zero, size:CGSize) {
        self.size = size
        self.tankType = type
        self.texture = textures[type]!
        self.startingPosition = startingPosition
        self.turrets = turret
    }
    convenience init(){
        self.init(type: .Circle, size: CGSize(width: 15, height: 15))
    }
    static func getTank() -> TankEntity{
        return TankEntity()
    }
}
class Turret{
    var position:CGPoint
    var rotation:CGFloat
    var turretSize:CGSize
	var node:SKShapeNode?
    init(position:CGPoint=CGPoint(x: 0, y: 0),rotation:CGFloat=0, size:CGSize=CGSize(width: 1, height: 1)) {
        self.position = position
        self.rotation = rotation
        self.turretSize = size
    }
    func getTurretRect(scale:CGFloat) -> CGRect{
		let width = turretSize.width * scale
		let height = turretSize.height * scale
        return CGRect(x: 0, y: -height/2.0, width: width, height: height)
    }
	
	func getTurretPosition(scale:CGFloat) -> CGPoint{
		return position * scale
	}
}
