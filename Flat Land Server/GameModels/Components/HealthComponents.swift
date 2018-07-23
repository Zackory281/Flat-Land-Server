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
    var health:CGFloat
    var maxHealth:CGFloat
    var healthPercent:CGFloat{ return health/maxHealth }
    var arena:ArenaDelegate?
    init(health:CGFloat=1, maxHealth:CGFloat=1) {
        self.health = health
        self.maxHealth = maxHealth
        super.init()
    }
    convenience init(health:CGFloat=1, maxHealth:CGFloat=1,arenaDelegate:ArenaDelegate?){
        self.init(health:health, maxHealth:maxHealth)
        self.arena = arenaDelegate
    }
    func isDead()->Bool{
        return health <= 0
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
