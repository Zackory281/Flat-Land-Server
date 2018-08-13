//
//  TankConfig.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 8/12/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation
import GameplayKit

//let twin:Tank = Tank(
func getTank(type:TankType) -> Tank{
	switch type {
	case .tank:
		return Tank(type: type, turret: [
			Turret(position: .zero, rotation: 0, size: CGSize(width: 1.5, height: 0.3), scale:45)
			], size: 45)
	case .twin:
		return Tank(type: type, turret: [
			Turret(position: CGPoint(x: 0, y: 0.25), rotation: 0, size: CGSize(width: 1.5, height: 0.3), scale:45, bullet:Bullet()),
			Turret(position: CGPoint(x: 0, y: -0.25), rotation: 0, size: CGSize(width: 1.5, height: 0.3), scale:45),
			], size: 45)
	}
}

enum TankType {
	case tank
	case twin
}
class Tank {
	var size:CGFloat
	var rotation:CGFloat = 0
	var tankType:TankType
	var turrets:[Turret] = []
	var tankNode:SKNode?
	let physicsBodyCategory = BodyCategory.Entity
	init(type:TankType, turret:[Turret], size:CGFloat) {
		self.size = size
		self.tankType = type
		self.turrets = turret
	}
}

class Turret{
	var position:CGPoint
	var rotation:CGFloat
	var turretSize:CGSize
	var scale:CGFloat
	var node:SKShapeNode?
	let bullet:Bullet
	init(position:CGPoint=CGPoint(x: 0, y: 0),rotation:CGFloat=0, size:CGSize=CGSize(width: 1, height: 1), scale:CGFloat=1, bullet:Bullet=Bullet()) {
		self.position = position
		self.rotation = rotation
		self.turretSize = size
		self.scale = scale
		self.bullet = bullet
	}
	func getTurretRect() -> CGRect{
		let width = turretSize.width * scale
		let height = turretSize.height * scale
		return CGRect(x: 0, y: -height/2.0, width: width, height: height)
	}
	
	func getTurretPosition() -> CGPoint{
		return position * scale
	}
}

struct Bullet {
	let radius:CGFloat
	let timeout:TimeInterval
	let speed:CGFloat
	let damage:CGFloat
	init(damage:CGFloat=0.5, radius:CGFloat=0.5,speed:CGFloat=400, timeout:TimeInterval=1) {
		self.damage = damage
		self.radius = radius
		self.timeout = timeout
		self.speed = speed
	}
}

struct BulletFire{
	let shooter:GKEntity
	let position:CGPoint
	let velocity:CGVector
}
