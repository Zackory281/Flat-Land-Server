//
//  Components.swift
//  Flat Land
//
//  Created by Zackory Cramer on 5/27/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class HealthComponent:GKComponent{
    var health:Double!
    var maxHealth:Double!
    var healthPercent:Double{ return health/maxHealth }
    var arena:ArenaDelegate?
	init(health:Double=1, maxHealth:Double=1,bullet:Bullet?=nil,arenaDelegate:ArenaDelegate?){
		super.init()
		if let bullet = bullet{
			self.health = bullet.health
			self.maxHealth = health
		}else{
			self.health = health
			self.maxHealth = maxHealth
		}
        self.arena = arenaDelegate
    }
    func isDead()->Bool{
        return health <= 0
    }
	func dockHealth(_ amount:Double){
		self.health -= amount
		if self.entity is FoodEntity{
			guard let node = self.entity?.component(ofType: SpriteComponent.self)?.spriteNode else {return}
			if let _ = node.action(forKey: "hurt"){}else{
				node.run(hurtAction, withKey: "hurt")
			}
		}
	}
    override func update(deltaTime seconds: TimeInterval) {
        if healthPercent <= 0{
            arena?.removeEntity(entity: entity!)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
