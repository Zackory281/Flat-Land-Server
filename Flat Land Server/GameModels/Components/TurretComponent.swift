//
//  TurretComponent.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/16/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class TurretComponent: GKComponent {
	
	lazy var firePeriod:TimeInterval = {
		return self.tankEntity!.tank.firePeriod
	}()
	var timeSinceLastFire:TimeInterval = 0
	var fireQueue:UInt8 = 0
	
	var turretRange:Float = 7000
	var tankEntity:ShapeTankEntity?{
		return entity as? ShapeTankEntity
	}
	lazy var subPeriod:TimeInterval = {
		return self.firePeriod / TimeInterval(self.tankEntity!.tank.fireIntervals)
	}()
	init(turretDelegate:TurretDelegate?, map:MapComponentDelegate?) {
		self.turretDelegate = turretDelegate
		self.map = map
		super.init()
	}
	var fireTick:Int = 0
	var recoil:CGVector!
	override func update(deltaTime seconds: TimeInterval) {
		timeSinceLastFire += seconds
		if timeSinceLastFire > firePeriod{
			fireTick = 0
			timeSinceLastFire = 0
		}
		guard let tankNode = tankEntity?.node else {return}
		recoil = .zero
		while timeSinceLastFire > subPeriod * TimeInterval(fireTick){
			tickFire(index: fireTick, tankNode: tankNode)
			fireTick += 1
		}
		while fireQueue != 0 {
			//			guard let tankNode = tankEntity?.node else {continue}
			//			for turretEntity in tankEntity!.turrets{
			//				guard let node = turretEntity.node else {continue}
			//				let turret = turretEntity.turret
			//				let scene = node.scene!
			//				let speed = turret.bullet.speed
			//				let rotation = tankEntity!.rotation
			//				let bulletFire = BulletFire.init(shooter: entity!,turret: turret, position: scene.convert(node.position, from: tankNode), velocity: CGVector(dx: speed * cos(rotation), dy: speed * sin(rotation)))
			//				turretDelegate?.fire(bullet:turret.bullet, bulletFire: bulletFire)
			//				timeSinceLastFire = 0
			//			}
			fireQueue -= 1
		}
	}
	
	weak var scene:SKScene?
	
	func tickFire(index:Int, tankNode:SKNode){
		for turretEntity in tankEntity!.turrets{
			guard let node = turretEntity.node, turretEntity.turret.fireIndex == index else {
				print("not of index");continue }
			let turret = turretEntity.turret
			let scene = node.scene!
			let speed = turret.bullet.speed
			let rotation = tankEntity!.rotation + turret.rotation
			let velocity = CGVector(dx: speed * cos(rotation), dy: speed * sin(rotation))
			let bulletFire = BulletFire.init(shooter: entity!,turret: turret, position: scene.convert(node.position+CGPoint(x: turretEntity.turretLength, y: 0), from: tankNode), velocity: velocity)
			turretDelegate?.fire(bullet:turret.bullet, bulletFire: bulletFire)
			turretEntity.node!.run(fireAction)
			recoil = recoil + velocity * turret.bullet.mass
		}
		entity?.component(ofType: PhysicsComponent.self)?.physicsBody.applyImpulse(recoil*(-1))
		recoil = .zero
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	var position:CGPoint?{ return self.entity?.component(ofType: SpriteComponent.self)?.spriteNode.position}
	var turretDelegate:TurretDelegate?
	var map:MapComponentDelegate?
}
