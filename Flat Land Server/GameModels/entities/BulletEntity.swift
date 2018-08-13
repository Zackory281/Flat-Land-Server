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
	weak var from:GKEntity?
	lazy var radius:CGFloat = {
		return (from! as! ShapeTankEntity).tank.size * bullet.radius
	}()
    var hitAction = {(_ bullet:BulletEntity, _ target:GKEntity)->() in
        guard let healthComp = target.component(ofType: HealthComponent.self), target != bullet.from else { return }
        healthComp.health -= bullet.bullet.damage
        bullet.healthComponent.health -= bullet.bullet.damage
    }
    let disapearFunction = { (entity:GKEntity) -> Bool in
        let disappearComponent:DisappearComponent = entity.component(ofType: DisappearComponent.self)!
        return entity.component(ofType: HealthComponent.self)!.isDead() || disappearComponent.passedTime > disappearComponent.timeOut
    }
	init(bullet:Bullet, scene:SceneComponentDelegate, arena:ArenaDelegate, bulletFire:BulletFire) {
        super.init()
        self.scene = scene
        self.arena = arena
        self.bullet = bullet
		
		self.from = bulletFire.shooter
		
        self.addComponent(DisappearComponent(function:disapearFunction, arena: arena))
        self.addComponent(SpriteComponent(bullet: self, scene:scene))
        self.addComponent(PhysicsComponent(bullet:self,category:.Bullet))
        self.addComponent(HealthComponent())
		
		spriteComponent.spriteNode.position = bulletFire.position
		physicsComponent.physicsBody.velocity = bulletFire.velocity
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
