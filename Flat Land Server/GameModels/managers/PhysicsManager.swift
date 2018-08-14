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
		case (FoodCate, FoodCate):
			repelStart(body1: contact.bodyA, body2: contact.bodyB)
		case (BulletCate, FoodCate):
			(body1.node?.entity as? BulletEntity)?.addHitEntity(entity: body2.node!.entity!)
			repelStart(body1: contact.bodyA, body2: contact.bodyB)
		default:
			break
		}
//        if contact.bodyA.categoryBitMask != BulletCate, contact.bodyB.categoryBitMask == BulletCate {
//        }else if contact.bodyB.categoryBitMask != BulletCate, contact.bodyA.categoryBitMask == BulletCate {
//            body1 = contact.bodyB; body2 = contact.bodyA;
//        }else { return }
//        guard let entity = delegate.getEntityOfBody(body: body1!, type: GKEntity.self) else {return}
//        guard let bulletEntity = delegate.getEntityOfBody(body: body2!, type: BulletEntity.self) else {return}
//		bulletEntity.addHitEntity(entity: entity)
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
		switch (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask) {
		case (FoodCate, FoodCate):
			repelEnd(body1: contact.bodyA, body2: contact.bodyB)
		default:
			break
		}
		var entityBody:SKPhysicsBody?
		var bulletBody:SKPhysicsBody?
		if contact.bodyA.categoryBitMask != BulletCate, contact.bodyB.categoryBitMask == BulletCate {
			entityBody = contact.bodyA; bulletBody = contact.bodyB;
		}else if contact.bodyB.categoryBitMask != BulletCate, contact.bodyA.categoryBitMask == BulletCate {
			entityBody = contact.bodyB; bulletBody = contact.bodyA;
		}else { return }
		guard let tankEntity = delegate.getEntityOfBody(body: entityBody!, type: BuildingEntity.self) else {return}
		guard let bulletEntity = delegate.getEntityOfBody(body: bulletBody!, type: BulletEntity.self) else {return}
		bulletEntity.removeHitEntity(entity: tankEntity)
    }
}

protocol PhysicsManagerDelegate{
    func getEntityOfBody<T>(body:SKPhysicsBody, type:T.Type) -> T?
}
