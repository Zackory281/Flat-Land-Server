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
	weak var hitEntity:GKEntity?
	weak var from:ShapeTankEntity?
	weak var turret:Turret?
	lazy var radius:CGFloat = {
		return turret!.turretSize.height * bullet.radius * from!.tank.size
	}()
	var hitAction = {(_ bullet:BulletEntity, _ target:GKEntity)->() in
		guard let healthComp = target.component(ofType: HealthComponent.self), target != bullet.from else { return }
		var dealtDamage:Double = bullet.bullet.damage
		if let targetHealth = target.component(ofType: HealthComponent.self)?.health{
			dealtDamage = min(dealtDamage, targetHealth)
			print(dealtDamage)
		}
		healthComp.health -= dealtDamage
		bullet.healthComponent.health -= dealtDamage
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
		
		self.from = bulletFire.shooter as? ShapeTankEntity
		self.turret = bulletFire.turret
		
		self.addComponent(DisappearComponent(function:disapearFunction,timeOut:bullet.timeout, arena: arena))
		self.addComponent(SpriteComponent(bullet: self, scene:scene))
		self.addComponent(PhysicsComponent(bullet:self,category:.Bullet))
		self.addComponent(HealthComponent(bullet:bullet ,arenaDelegate: arena))
		
		spriteComponent.spriteNode.position = bulletFire.position
		physicsComponent.physicsBody.velocity = bulletFire.velocity
	}
	override func update(deltaTime seconds: TimeInterval) {
		if let hitEntity = hitEntity{
			hitAction(self, hitEntity)
		}
	}
	func removeHitEntity(entity:GKEntity){
		if let hitEntity = hitEntity, hitEntity == entity{
			self.hitEntity = nil
		}
	}
	func addHitEntity(entity:GKEntity){
		if let hitEntity = hitEntity, hitEntity != entity{
			self.hitEntity = entity
		}else{
			self.hitEntity = entity
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
