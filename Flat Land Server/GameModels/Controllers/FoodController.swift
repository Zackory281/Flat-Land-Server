//
//  FoodControlelr.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 8/12/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation
import GameplayKit

class FoodController{
	weak var arenaDelegate:ArenaDelegate?
	weak var foodControllerDelegate:FoodControllerDelegate?
	let spawnTime:TimeInterval = 1.0
	var time:TimeInterval = 0
	var spawnLimit:UInt = 30
	var spawned:UInt = 0
	
	init(arenaDelegate:ArenaDelegate?=nil, foodControllerDelegate:FoodControllerDelegate?=nil) {
		self.arenaDelegate = arenaDelegate
		self.foodControllerDelegate = foodControllerDelegate
	}
	
	func spawn(){
		if spawned < spawnLimit{
			guard let foodControllerDelegate = foodControllerDelegate else {return}
			foodControllerDelegate.spawnFood(foodSpawn: FoodSpawn(food: Food(foodType: .Triangle), position: CGPoint(x: 600, y: 600)))
			spawned += 1
		}
	}
	
	func update(seconds:TimeInterval){
		time += seconds
		while time > spawnTime {
			spawn()
			time -= spawnTime
		}
	}
}

extension ArenaModel{
	func spawnFood(foodSpawn:FoodSpawn){
		self.addEntity(entity: FoodEntity(sceneDelegate: sceneManager, arenaDelegate: self, foodSpawn: foodSpawn))
	}
}

protocol FoodControllerDelegate: class{
	func spawnFood(foodSpawn:FoodSpawn)
}

struct Food {
	let foodType:FoodType
}

struct FoodSpawn {
	let food:Food
	let position:CGPoint
}
