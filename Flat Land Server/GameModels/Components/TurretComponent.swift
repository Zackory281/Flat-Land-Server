//
//  TurretComponent.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/16/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class TurretComponent: GKComponent {
    
    var firePeriod:TimeInterval = 1.5
    var timeSinceLastFire:TimeInterval = 0
    
    var turretRotation:CGFloat{
        return entity?.component(ofType: SpriteComponent.self)?.spriteNode.zRotation ?? 0
    }
    var turretRange:Float = 700
    var bulletSpeed:CGFloat = 200
    var bulletSize:CGSize = CGSize(width: 20, height: 20)
    
    init(turret:TurretDelegate?, map:MapComponentDelegate?) {
        super.init()
        self.turret = turret
        self.map = map
    }
    override func update(deltaTime seconds: TimeInterval) {
        timeSinceLastFire += seconds
        while timeSinceLastFire > firePeriod{
            guard let position = position, let target = map?.getAim(from: toVector_2f(position), maxDistance: turretRange)?.closestEntity else {return}
            let diff = target.building.position - position
            turret?.fire(bullet:getBullet(velocity: CGVector.normalize(vector: diff)*bulletSpeed))
            timeSinceLastFire = 0
        }
    }
    func getBullet()->Bullet{
        return getBullet(velocity:CGVector(dx: 10, dy: 10))
    }
    func getBullet(velocity:CGVector) -> Bullet{
        return Bullet(texture: nil, start: position ?? CGPoint.zero, velocity: velocity, size: bulletSize, from:entity)
    }
    func getBullet(angle:CGFloat) -> Bullet{
        return Bullet(texture: nil, start: position ?? CGPoint.zero, speed:bulletSpeed, rotation:angle, size: bulletSize, from:entity)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var position:CGPoint?{ return self.entity?.component(ofType: SpriteComponent.self)?.spriteNode.position}
    var turret:TurretDelegate?
    var map:MapComponentDelegate?
}
