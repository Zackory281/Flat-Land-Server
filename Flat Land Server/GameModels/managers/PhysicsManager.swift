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
        var entityBody:SKPhysicsBody?
        var bulletBody:SKPhysicsBody?
        if contact.bodyA.categoryBitMask != BulletCate, contact.bodyB.categoryBitMask == BulletCate {
            entityBody = contact.bodyA; bulletBody = contact.bodyB;
        }else if contact.bodyB.categoryBitMask != BulletCate, contact.bodyA.categoryBitMask == BulletCate {
            entityBody = contact.bodyB; bulletBody = contact.bodyA;
        }else { return }
        guard let tankEntity = delegate.getEntityOfBody(body: entityBody!, type: BuildingEntity.self) else {return}
        guard let bulletEntity = delegate.getEntityOfBody(body: bulletBody!, type: BulletEntity.self) else {return}
		bulletEntity.addHitEntity(entity: tankEntity)
    }
    func didEnd(_ contact: SKPhysicsContact) {
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
