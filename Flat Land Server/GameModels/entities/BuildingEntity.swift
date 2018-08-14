//
//  BuildingEntity.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/16/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class BuildingEntity: GKEntity {
    var scene:SceneComponentDelegate
    var building:Building
    var position:float2
    var disappearFunction = { (entity:GKEntity) -> Bool in
        return entity.component(ofType: HealthComponent.self)?.isDead() ?? false
    }
    init(building:Building, scene:SceneComponentDelegate, arena:ArenaDelegate) {
        self.scene = scene
        self.building = building
        self.position = toVector_2f(building.position)
        super.init()
        self.addComponent(SpriteComponent.init(building: building, scene:scene))
        self.addComponent(PhysicsComponent(building: building))
		self.addComponent(HealthComponent(health:30, maxHealth:30, arenaDelegate:arena))
        self.addComponent(DisappearComponent(function: disappearFunction, arena: arena))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var turretComponent:TurretComponent{ return self.component(ofType: TurretComponent.self)! }
    var spriteComponent:SpriteComponent{ return self.component(ofType: SpriteComponent.self)! }
    var healthComponent:HealthComponent{ return self.component(ofType: HealthComponent.self)! }
}

struct Building {
    var size:CGSize
    var position:CGPoint
    init(size:CGSize, position:CGPoint) {
        self.size = size
        self.position = position
    }
    func getSpriteRect() -> CGRect {
        return CGRect(x: 0-size.width/2, y: -size.height/2, width: size.width, height: size.height)
    }
    static func getBuilding(_ x:CGFloat,_ y:CGFloat) -> Building{
        return Building(size: CGSize(width: 200, height: 200), position:CGPoint(x: x, y: y))
    }
}
