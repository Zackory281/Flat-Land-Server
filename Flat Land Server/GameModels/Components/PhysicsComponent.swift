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
	var repellees:WeakSet = WeakSet<SKNode>()
	var randomVelocity:CGVector?
	override init() {
		physicsBody = SKPhysicsBody(texture: SKTexture(image:#imageLiteral(resourceName: "triangle")), size: CGSize(width: 30, height: 30))
		super.init()
	}
	init(bullet:BulletEntity, category:BodyCategory) {
		physicsBody = SKPhysicsBody(circleOfRadius: bullet.radius)
		physicsBody.mass = 100
		physicsBody.friction = 0
		physicsBody.isDynamic = true
		
		super.init()
		setCategory(category: category)
	}
	init(tank:Tank) {
		physicsBody = SKPhysicsBody(circleOfRadius: tank.size/2)
		physicsBody.mass = tank.mass
		//physicsBody.friction = 1.5
		physicsBody.isDynamic = true
		physicsBody.allowsRotation = false
		super.init()
		setCategory(category: tank.physicsBodyCategory)
	}
	init(buildingEntity:BuildingEntity) {
		physicsBody = SKPhysicsBody(rectangleOf: buildingEntity.building.size)
		physicsBody.restitution = 0.3
		physicsBody.isDynamic = false
		physicsBody.friction = 0
		physicsBody.mass = 100
		super.init()
		setCategory(category: .Building)
	}
	init(foodEntity:FoodEntity){
		physicsBody = SKPhysicsBody(circleOfRadius: foodEntity.size)
		physicsBody.isDynamic = true
		physicsBody.mass = 0.1
		physicsBody.velocity = CGVector(dx: 0, dy: 0)
		frictionCoef = 1
		self.randomVelocity = getRandomVector(10)
		super.init()
		setCategory(category: .Food)
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
		if let tankEntity = entity! as? ShapeTankEntity{
			physicsBody.applyForce(forceDirection*tankEntity.tank.force+frictionForce)
		}
		if let _ = entity! as? FoodEntity{
			physicsBody.applyForce(randomVelocity! - physicsBody.velocity * frictionCoef)
		}
		for repellee in repellees.allObjects{
			switch repellee.physicsBody?.categoryBitMask{
			case FoodCate:
				repellee.physicsBody?.applyImpulse((repellee.position - physicsBody.node!.position)*0.5)
			case EntityCate:
				repellee.physicsBody?.applyImpulse((repellee.position - physicsBody.node!.position)*3)
			case BulletCate:
				physicsBody.applyImpulse(repellee.physicsBody!.velocity*0.002)
			default:
				break
			}
		}
	}
	var frictionCoef:CGFloat = 20
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
	.Entity  :  (cate:EntityCate,
				 coll:EntityCate | BuildingCate,
				 cont:EntityCate | FoodCate),
	.Food  :  (cate: FoodCate,
			   coll: BuildingCate,
			   cont:BulletCate | FoodCate),
	.Bullet  :  (cate:BulletCate,
				 coll:UInt32(0),
				 cont:BuildingCate | FoodCate),
	.Building:  (cate:BuildingCate,
				 coll:UInt32.fill(32),
				 cont:UInt32.fill(32)),
	
]
let NothingCate:UInt32 = UInt32.shift(32)
let EntityCate:UInt32 = UInt32.shift(0)
let BulletCate:UInt32 = UInt32.shift(1)
let BuildingCate:UInt32 = UInt32.shift(2)
let FoodCate:UInt32 = UInt32.shift(3)

enum BodyCategory {
	case Nothing
	case Entity
	case Bullet
	case Food
	case Building
}

