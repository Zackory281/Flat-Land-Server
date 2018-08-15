//
//  FoodEntity.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 8/12/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation
import GameplayKit

class FoodEntity:GKEntity {
	
	lazy var foodType:FoodType = {
		return self.food.foodType
	}()
	let food:Food
	lazy var size:CGFloat = {
		return self.food.foodSize
	}()
	var shapePath:CGPath!
	init(sceneDelegate:SceneComponentDelegate, arenaDelegate:ArenaDelegate, foodSpawn:FoodSpawn) {
		self.food = foodSpawn.food
		self.shapePath = getFoodPath(food.foodType, size: food.foodSize)
		super.init()
		self.addComponent(SpriteComponent(foodEntity: self, scene: sceneDelegate))
		self.addComponent(PhysicsComponent(foodEntity: self))
		self.addComponent(HealthComponent(health:10,maxHealth:10,arenaDelegate: arenaDelegate))
		self.spriteComponent.spriteNode.position = foodSpawn.position
		physicsComponent.physicsBody.angularVelocity = getRandomDouble()-0.5
	}
	
	override func update(deltaTime seconds: TimeInterval) {
		//physicsComponent.physicsBody.applyImpulse(getRandomVector(10))
	}
	var spriteNode:SKSpriteNode{return self.spriteComponent.spriteNode as! SKSpriteNode}
	var spriteComponent:SpriteComponent{ return self.component(ofType: SpriteComponent.self)! }
	var healthComponent:HealthComponent{ return self.component(ofType: HealthComponent.self)! }
	var physicsComponent:PhysicsComponent{ return self.component(ofType: PhysicsComponent.self)! }
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
struct FoodInit {
	
}
enum FoodType {
	case Triangle
	case Square
}
