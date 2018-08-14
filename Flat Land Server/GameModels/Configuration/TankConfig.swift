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
			Turret(position: CGPoint(x: 0, y: 0.3), rotation: 0, size: CGSize(width: 1, height: 0.4), scale:45),
			Turret(position: CGPoint(x: 0, y: -0.3), rotation: 0, size: CGSize(width: 1, height: 0.4), scale:45),
			], size: 45)
	case .triplet:
		return Tank(type: type, turret: [
			Turret(position: CGPoint(x: 0, y:  0.3), rotation: 0, size: CGSize(width: 0.8, height: 0.4), scale:45,fireIndex:0,zBuffer:-1),
			Turret(position: CGPoint(x: 0, y:  0.0), rotation: 0, size: CGSize(width: 1.0, height: 0.4), scale:45,fireIndex:1,zBuffer:0),
			Turret(position: CGPoint(x: 0, y: -0.3), rotation: 0, size: CGSize(width: 0.8, height: 0.4), scale:45,fireIndex:0,zBuffer:-1),
			], size: 45, fireIntervals: 2)
	case .destroyer:
		return Tank(type: type, turret: [
			Turret(position: CGPoint(x: 0, y:  0), rotation: 0, size: CGSize(width: 1.0, height: 0.65), scale:45, bullet:Bullet(damage:200, mass:0.5),fireIndex:0,zBuffer:0),
			], size: 45)
	case .octatank:
		return Tank(type: type, turret: [
			Turret(position: CGPoint(x: 0, y: 0), rotation: CGFloat.pi/4*0, size: CGSize(width: OCTATANKWIDTH, height: OCTATANKHEIGHT), scale:45, bullet:Bullet(damage:2, mass:0.5),fireIndex:0,zBuffer:0),
			Turret(position: CGPoint(x: 0, y: 0), rotation: CGFloat.pi/4*1, size: CGSize(width: OCTATANKWIDTH, height: OCTATANKHEIGHT), scale:45, bullet:Bullet(damage:2, mass:0.5),fireIndex:1,zBuffer:-1),
			Turret(position: CGPoint(x: 0, y: 0), rotation: CGFloat.pi/4*2, size: CGSize(width: OCTATANKWIDTH, height: OCTATANKHEIGHT), scale:45, bullet:Bullet(damage:2, mass:0.5),fireIndex:0,zBuffer:0),
			Turret(position: CGPoint(x: 0, y: 0), rotation: CGFloat.pi/4*3, size: CGSize(width: OCTATANKWIDTH, height: OCTATANKHEIGHT), scale:45, bullet:Bullet(damage:2, mass:0.5),fireIndex:1,zBuffer:-1),
			Turret(position: CGPoint(x: 0, y: 0), rotation: CGFloat.pi/4*4, size: CGSize(width: OCTATANKWIDTH, height: OCTATANKHEIGHT), scale:45, bullet:Bullet(damage:2, mass:0.5),fireIndex:0,zBuffer:0),
			Turret(position: CGPoint(x: 0, y: 0), rotation: CGFloat.pi/4*5, size: CGSize(width: OCTATANKWIDTH, height: OCTATANKHEIGHT), scale:45, bullet:Bullet(damage:2, mass:0.5),fireIndex:1,zBuffer:-1),
			Turret(position: CGPoint(x: 0, y: 0), rotation: CGFloat.pi/4*6, size: CGSize(width: OCTATANKWIDTH, height: OCTATANKHEIGHT), scale:45, bullet:Bullet(damage:2, mass:0.5),fireIndex:0,zBuffer:0),
			Turret(position: CGPoint(x: 0, y: 0), rotation: CGFloat.pi/4*7, size: CGSize(width: OCTATANKWIDTH, height: OCTATANKHEIGHT), scale:45, bullet:Bullet(damage:2, mass:0.5),fireIndex:1,zBuffer:-1),
			], size: 45, fireIntervals: 2)
	}
}

let OCTATANKWIDTH:Double = 0.8
let OCTATANKHEIGHT:Double = 0.7653/2

enum TankType {
	case tank
	case twin
	case triplet
	case destroyer
	case octatank
}
class Tank {
	var size:CGFloat
	var rotation:CGFloat = 0
	var tankType:TankType
	var turrets:[Turret] = []
	let physicsBodyCategory = BodyCategory.Entity
	let fireIntervals:Int
	let mass:CGFloat
	let force:CGFloat
	let firePeriod:TimeInterval
	init(type:TankType, turret:[Turret], size:CGFloat, mass:CGFloat=10, force:CGFloat=5000, fireIntervals:Int=1,firePeriod:TimeInterval=1) {
		self.size = size
		self.tankType = type
		self.turrets = turret
		self.fireIntervals = fireIntervals
		self.mass = mass
		self.force = force
		self.firePeriod = firePeriod
	}
}

class Turret{
	let position:CGPoint
	let rotation:CGFloat
	let turretSize:CGSize
	let scale:CGFloat
	let bullet:Bullet
	let fireIndex:Int
	let zBuffer:CGFloat
	init(position:CGPoint=CGPoint(x: 0, y: 0),rotation:CGFloat=0, size:CGSize=CGSize(width: 1, height: 1), scale:CGFloat=1, bullet:Bullet=Bullet(),fireIndex:Int=0, zBuffer:CGFloat=0) {
		self.position = position
		self.rotation = rotation
		self.turretSize = size
		self.scale = scale
		self.bullet = bullet
		self.fireIndex = fireIndex
		self.zBuffer = zBuffer
	}
}

struct Bullet {
	let radius:CGFloat
	let timeout:TimeInterval
	let speed:CGFloat
	let damage:Double
	let health:Double
	let mass:CGFloat
	init(health:Double?=nil,damage:Double=0.5, radius:CGFloat=0.5,speed:CGFloat=200, mass:CGFloat=0.1, timeout:TimeInterval=1) {
		self.damage = damage
		self.radius = radius
		self.timeout = timeout
		self.speed = speed
		self.mass = mass
		if health == nil{
			self.health = damage
		}else{
			self.health = health!
		}
	}
}

struct BulletFire{
	weak var shooter:GKEntity?
	let turret:Turret
	let position:CGPoint
	let velocity:CGVector
}
