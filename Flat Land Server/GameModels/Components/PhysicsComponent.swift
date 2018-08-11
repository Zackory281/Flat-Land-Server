//
//  PhysicsComponent.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/16/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class PhysicsComponent: GKComponent {
    var physicsBody:SKPhysicsBody
    var spriteNode:SKNode?{
        return entity?.component(ofType: SpriteComponent.self)?.spriteNode
    }
    var forceDirection:CGVector = CGVector.zero
    override init() {
        physicsBody = SKPhysicsBody(texture: SKTexture(image:#imageLiteral(resourceName: "triangle")), size: CGSize(width: 30, height: 30))
        super.init()
    }
    init(bullet:Bullet, category:BodyCategory) {
        physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        physicsBody.velocity = bullet.startVelocity
        physicsBody.mass = 100
        physicsBody.friction = 0
        physicsBody.isDynamic = true
        super.init()
        setCategory(category: category)
    }
    init(tank:TankEntity) {
        physicsBody = SKPhysicsBody(circleOfRadius: tank.size.width/2)
        physicsBody.mass = 1
        //physicsBody.friction = 1.5
        physicsBody.isDynamic = true
		physicsBody.allowsRotation = false
        super.init()
        setCategory(category: tank.physicsBodyCategory)
    }
    init(building:Building) {
        physicsBody = SKPhysicsBody(rectangleOf: building.size)
        physicsBody.restitution = 0.3
        physicsBody.isDynamic = false
        physicsBody.friction = 0
        physicsBody.mass = 100
        super.init()
        setCategory(category: .Building)
    }
    func setCategory(category:BodyCategory) -> Void {
        let masks = categoryKey[category]!
        physicsBody.categoryBitMask = masks.cate
        physicsBody.collisionBitMask = masks.coll
        physicsBody.contactTestBitMask = masks.cont
    }
    override func update(deltaTime seconds: TimeInterval) {
        
        if spriteNode != nil, spriteNode?.physicsBody == nil{
            spriteNode!.physicsBody = self.physicsBody
        }
        physicsBody.applyForce(forceDirection+frictionForce)
    }
	var frictionCoef:CGFloat = 2
	var frictionForce:CGVector{
		return self.physicsBody.velocity * -frictionCoef
	}
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
let categoryKey:[BodyCategory:(cate:UInt32, coll:UInt32,cont:UInt32)] = [
    .Nothing :  (cate:UInt32.shift(32),
                 coll:UInt32.shift(32),
                 cont:UInt32(0)),
    .Entity  :  (cate:UInt32.shift(0),
                 coll:EntityCate | BuildingCate,
                 cont:UInt32(0)),
    .Bullet  :  (cate:UInt32.shift(1),
                 coll:UInt32(0),
                 cont:BuildingCate),
    .Building:  (cate:UInt32.shift(2),
                 coll:UInt32.fill(32),
                 cont:UInt32.fill(32)),
    
]
let EntityCate:UInt32 = UInt32.shift(0)
let BulletCate:UInt32 = UInt32.shift(1)
let BuildingCate:UInt32 = UInt32.shift(2)
enum BodyCategory {
    case Nothing
    case Entity
    case Bullet
    case Building
}
