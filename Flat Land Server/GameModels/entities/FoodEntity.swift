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
	let foodType:FoodType = .Triangle
	init(sceneDelegate:SceneComponentDelegate, arenaDelegate:ArenaDelegate, type:FoodType, position:CGPoint) {
		super.init()
		self.addComponent(SpriteComponent(foodEntity:self, scene: sceneDelegate))
		self.addComponent(PhysicsComponent(foodType: .Triangle))
		self.addComponent(HealthComponent(arenaDelegate: arenaDelegate))
		self.spriteComponent.spriteNode.position = position
	}
	
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
}
