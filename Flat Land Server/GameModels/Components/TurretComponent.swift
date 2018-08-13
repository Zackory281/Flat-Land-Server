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
    
    var firePeriod:TimeInterval = 1.5
    var timeSinceLastFire:TimeInterval = 0
	var fireQueue:UInt8 = 0
	
    var turretRange:Float = 700
    var bulletSpeed:CGFloat = 400
    var bulletSize:CGSize = CGSize(width: 20, height: 20)
	var tank:Tank
    
	init(tank:Tank, turretDelegate:TurretDelegate?, map:MapComponentDelegate?) {
		self.turretDelegate = turretDelegate
		self.map = map
		self.tank = tank
        super.init()
    }
    override func update(deltaTime seconds: TimeInterval) {
        timeSinceLastFire += seconds
        while timeSinceLastFire > firePeriod{
//			guard let turretDelegate = turretDelegate else {print("no turret delegate"); return}
//			for turret in tank.turrets{
//				let node = turret.node!
//				let scene = node.scene!
//				turretDelegate.fire(bullet:getBullet(angle: turret.rotation + tank.rotation, position:scene.convert(node.position, from: tank.tankNode!)))
//
//			}
			timeSinceLastFire = 0
        }
		while fireQueue != 0 {
			for turret in tank.turrets{
				let node = turret.node!
				let scene = node.scene!
				turretDelegate?.fire(bullet:getBullet(angle: turret.rotation + tank.rotation, position:scene.convert(node.position, from: tank.tankNode!)))
				timeSinceLastFire = 0
			}
			fireQueue-=1
		}
    }
    func getBullet()->Bullet{
        return getBullet(velocity:CGVector(dx: 10, dy: 10))
    }
    func getBullet(velocity:CGVector) -> Bullet{
        return Bullet(texture: nil, start: position ?? CGPoint.zero, velocity: velocity, size: bulletSize, from:entity)
    }
	func getBullet(angle:CGFloat, position:CGPoint) -> Bullet{
        return Bullet(texture: nil, start: position, speed:bulletSpeed, rotation:angle, size: bulletSize, from:entity)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var position:CGPoint?{ return self.entity?.component(ofType: SpriteComponent.self)?.spriteNode.position}
    var turretDelegate:TurretDelegate?
    var map:MapComponentDelegate?
}
