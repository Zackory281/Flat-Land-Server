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
	let spawnTime:TimeInterval = 1.0
	var time:TimeInterval = 0
	
	init(arenaDelegate:ArenaDelegate?=nil) {
		self.arenaDelegate = arenaDelegate
	}
	
	func update(seconds:TimeInterval){
		time += seconds
		while time > spawnTime {
			guard let arenaDelegate = arenaDelegate else {return}
			//arenaDelegate.addEntityOfType(FoodEntity.self)
			time -= spawnTime
		}
	}
}
