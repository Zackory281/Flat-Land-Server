//
//  PhysicsManager.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/15/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class PhysicsManager: NSObject, SKPhysicsContactDelegate {
    var physicsWorld:SKPhysicsWorld
    var delegate:PhysicsManagerDelegate
    init(physicsWorld:SKPhysicsWorld, delegate:PhysicsManagerDelegate) {
        self.physicsWorld = physicsWorld
        self.delegate = delegate
        super.init()
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
    }
    func didBegin(_ contact: SKPhysicsContact) {
        var body1:SKPhysicsBody = contact.bodyA//entity,
        var body2:SKPhysicsBody = contact.bodyB//bullet
		if body2.categoryBitMask < body1.categoryBitMask{
			let temp = body1
			body1 = body2
			body2 = temp
		}
		//print(contact.bodyA.node?.entity)
		switch (body1.categoryBitMask, body2.categoryBitMask) {
		case (FoodCate, FoodCate),(EntityCate, FoodCate):
			repelStart(body1: body1, body2: body2)
		case (BulletCate, FoodCate):
			guard let entity2 = body2.node?.entity else{ return}
			repelStart(body1: body1, body2: body2)
			(body1.node?.entity as? BulletEntity)?.addHitEntity(entity: entity2)
		default:
			break
		}
    }
	/*
	let NothingCate:UInt32 = UInt32.shift(32)
	let EntityCate:UInt32 = UInt32.shift(0)
	let BulletCate:UInt32 = UInt32.shift(1)
	let BuildingCate:UInt32 = UInt32.shift(2)
	let FoodCate:UInt32 = UInt32.shift(3)
*/
	func repelStart(body1:SKPhysicsBody, body2:SKPhysicsBody) {
		body1.node?.entity?.component(ofType: PhysicsComponent.self)?.repellees.add(body2.node!)
		body2.node?.entity?.component(ofType: PhysicsComponent.self)?.repellees.add(body1.node!)
	}
	func repelEnd(body1:SKPhysicsBody, body2:SKPhysicsBody) {
		body1.node?.entity?.component(ofType: PhysicsComponent.self)?.repellees.remove(body2.node!)
		body2.node?.entity?.component(ofType: PhysicsComponent.self)?.repellees.remove(body1.node!)
	}
    func didEnd(_ contact: SKPhysicsContact) {
		var body1:SKPhysicsBody = contact.bodyA//entity,
		var body2:SKPhysicsBody = contact.bodyB//bullet
		if body2.categoryBitMask < body1.categoryBitMask{
			let temp = body1
			body1 = body2
			body2 = temp
		}
		//print(contact.bodyA.node?.entity)
		switch (body1.categoryBitMask, body2.categoryBitMask) {
		case (FoodCate, FoodCate),(EntityCate, FoodCate):
			repelEnd(body1: body1, body2: body2)
		case (BulletCate, FoodCate):
			guard let entity2 = body2.node?.entity else{ return}
			repelEnd(body1: body1, body2: body2)
			(body1.node?.entity as? BulletEntity)?.addHitEntity(entity: entity2)
		default:
			break
		}
    }
}

protocol PhysicsManagerDelegate{
    func getEntityOfBody<T>(body:SKPhysicsBody, type:T.Type) -> T?
}
