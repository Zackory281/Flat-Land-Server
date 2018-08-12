//
//  BulletEntity.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/15/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class BulletEntity: GKEntity {
	var hitEntity = Set<GKEntity>()
    var hitAction = {(_ bullet:BulletEntity, _ target:GKEntity)->() in
        guard let healthComp = target.component(ofType: HealthComponent.self), target != bullet.bullet.from else { return }
        healthComp.health -= bullet.bullet.damage
        bullet.healthComponent.health -= bullet.bullet.damage
    }
    let disapearFunction = { (entity:GKEntity) -> Bool in
        let disappearComponent:DisappearComponent = entity.component(ofType: DisappearComponent.self)!
        return entity.component(ofType: HealthComponent.self)!.isDead() || disappearComponent.passedTime > disappearComponent.timeOut
    }
    init(bullet:Bullet, scene:SceneComponentDelegate, arena:ArenaDelegate) {
        super.init()
        self.scene = scene
        self.arena = arena
        self.bullet = bullet
        self.addComponent(DisappearComponent(function:disapearFunction, arena: arena))
        self.addComponent(SpriteComponent(bullet: bullet, scene:scene))
        self.addComponent(PhysicsComponent(bullet:bullet,category:.Bullet))
        self.addComponent(HealthComponent())
        spriteComponent.spriteNode.position = bullet.startPosition
        
    }
	override func update(deltaTime seconds: TimeInterval) {
		hitEntity.forEach { [weak self] entity in
			hitAction(self!, entity)
		}
	}
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var bullet:Bullet!
    var arena:ArenaDelegate!
    var scene:SceneComponentDelegate!
    var spriteComponent:SpriteComponent{ return self.component(ofType: SpriteComponent.self)!}
    var disappearComponent:DisappearComponent{ return self.component(ofType: DisappearComponent.self)!}
    var physicsComponent:PhysicsComponent{ return self.component(ofType: PhysicsComponent.self)!}
    var healthComponent:HealthComponent{ return self.component(ofType: HealthComponent.self)!}
}

struct Bullet {
    let startPosition:CGPoint
    let startVelocity:CGVector
    let size:CGSize
    let timeout:Double = 1.0
    let damage:CGFloat = 0.2
    
    weak var from:GKEntity?
    init(texture:SKTexture?, start:CGPoint, velocity:CGVector, size:CGSize, from:GKEntity?=nil) {
        self.startPosition = start
        self.startVelocity = velocity
        self.size = size
        self.from = from
    }
    init(texture:SKTexture?, start:CGPoint, speed:CGFloat, rotation:CGFloat, size:CGSize, from:GKEntity?=nil) {
        self.startPosition = start
        self.startVelocity = CGVector(dx: speed * cos(rotation), dy: speed * sin(rotation))
        self.size = size
        self.from = from
    }
}
