//
//  SpriteComponent.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/15/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class SpriteComponent:GKComponent{
    var spriteNode:SKNode
    var healthBar:SKShapeNode?
    init(polygon:EntityType, scene:SceneComponentDelegate?=nil) {
        spriteNode = SKSpriteNode(texture: textures[polygon]!)
        spriteNode.xScale = 1/6
        spriteNode.yScale = 1/6
        self.scene = scene
        super.init()
    }
    init(tankEntity:ShapeTankEntity, scene:SceneComponentDelegate?=nil) {
        let spriteNode = SKShapeNode(circleOfRadius: tankEntity.tank.size/2)
        spriteNode.fillColor = NSColor(red:0.00, green:0.69, blue:0.88, alpha:1.0)
        spriteNode.strokeColor = NSColor(red:0.32, green:0.32, blue:0.32, alpha:1.0)
        spriteNode.lineWidth = 3
        for turretEntity in tankEntity.turrets{
			let turret = turretEntity.turret
            let turretNode = SKShapeNode(rect: turretEntity.getTurretRect())
            turretNode.fillColor = NSColor(red:0.60, green:0.60, blue:0.60, alpha:1.0)
            turretNode.strokeColor = NSColor(red:0.45, green:0.45, blue:0.45, alpha:1.0)
            turretNode.lineWidth = 3
            turretNode.zPosition = -10
			turretNode.zRotation = turret.rotation
			turretNode.position = turretEntity.getTurretPosition()
            //let action = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.8), SKAction.scale(to: 2, duration: 0.1), SKAction.scale(to: 1.0, duration: 0.1)]))
			turretNode.zPosition = TURRETZBUFFER + turret.zBuffer
            turretEntity.node = turretNode
            spriteNode.addChild(turretNode)
        }
		spriteNode.zPosition = TANKZBUFFER
		spriteNode.entity = tankEntity
	  	tankEntity.node = spriteNode
        self.spriteNode = spriteNode
        self.scene = scene
        super.init()
    }
    init(_ x:Int,_ y:Int,_ width:Int,_ height:Int,label text:String, scene:SceneComponentDelegate?=nil) {
        spriteNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height))
        spriteNode.alpha = 0.6
        spriteNode.position = CGPoint(x: x, y: y)
        (spriteNode as! SKShapeNode).fillColor = NSColor.gray
        (spriteNode as! SKShapeNode).strokeColor = NSColor.black
        let font:NSFont = NSFont(name: "HelveticaNeue-Light", size: 14)!
        let key:[NSAttributedStringKey:Any] = [
            NSAttributedStringKey.strokeWidth:4,
            NSAttributedStringKey.font:font,
            NSAttributedStringKey.strokeColor:NSColor.black,
            ]
        let string = NSAttributedString(string: text, attributes: key)
        let label = SKLabelNode()
        if #available(OSX 13.0, *){
            label.attributedText = string
        }else{
            label.text = text
        }
        label.fontColor = NSColor.black
        label.color = NSColor.black
        label.position = CGPoint(x:width/2,y:height/2)
        spriteNode.addChild(label)
        self.scene = scene
        super.init()
    }
    init(building:Building, scene:SceneComponentDelegate?=nil) {
        self.scene = scene
        spriteNode = SKShapeNode(rect: building.getSpriteRect())
        spriteNode.position = building.position
        (spriteNode as! SKShapeNode).fillColor = .gray
        (spriteNode as! SKShapeNode).strokeColor = .black
        super.init()
    }
    init(bullet:BulletEntity, scene:SceneComponentDelegate?=nil) {
        let circle = SKShapeNode(circleOfRadius: bullet.radius)
        circle.fillColor = NSColor(red:0.93, green:0.38, blue:0.38, alpha:1.0)
        circle.strokeColor = .black
        circle.lineWidth = bullet.radius/4
		circle.zPosition = BULLETZBUFFER
		circle.entity = bullet
        self.spriteNode = circle
        self.scene = scene
        super.init()
    }
	init(foodEntity:FoodEntity, scene:SceneComponentDelegate) {
		self.scene = scene
		let node = SKShapeNode(path: foodEntity.shapePath, centered: true)
		let colors = foodColors[foodEntity.foodType]!
		node.fillColor = colors.fill
		node.strokeColor = colors.stroke
		node.lineWidth = 3
		let texture = scene.getTexture(node: node)
		let spriteNode = SKSpriteNode(texture: texture)
		spriteNode.entity = foodEntity
		self.spriteNode = spriteNode
		super.init()
	}
    var bar:SKShapeNode?
    override func update(deltaTime seconds: TimeInterval) {
        if spriteNode.parent == nil{
            if scene != nil{
                scene!.addNode(node: spriteNode)
            }
        }
        if let health = healtComponent?.healthPercent, spriteNode.parent != nil {
            if healthBar == nil{
                healthBar = SKShapeNode(rect: CGRect(x: -20, y: 20, width: 40, height: 3))
            }
            if let _ = bar?.parent{
                bar?.removeFromParent()
            }
            bar = SKShapeNode(rect: CGRect(x: -20, y: 20, width: 40 * health, height: 3))
            bar!.fillColor = .green
            healthBar!.fillColor = .gray
            if bar!.parent == nil{
                healthBar!.addChild(bar!)
            }
            healthBar!.position = spriteNode.position + CGPoint(x: 0, y: 25)
            if healthBar!.parent == nil{
                scene!.addNode(node: healthBar!)
            }
        }
		if let tank = self.entity as? ShapeTankEntity{
			spriteNode.zRotation = tank.rotation
		}
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        self.spriteNode.removeAllActions()
        self.spriteNode.removeAllChildren()
        spriteNode.physicsBody?.collisionBitMask = UInt32(0)
        spriteNode.physicsBody?.categoryBitMask = UInt32(0)
        let scale = SKAction.scale(by: 1.5, duration: 0.1)
        let alpha = SKAction.fadeAlpha(to: 0, duration: 0.1)
        let parallel = SKAction.group([alpha, scale])
        let remove = SKAction.removeFromParent()
        spriteNode.run(SKAction.sequence([parallel, remove]))
        healthBar?.removeAllChildren()
        healthBar?.removeAllActions()
        healthBar?.removeFromParent()
        bar?.removeAllChildren()
        bar?.removeAllActions()
        bar?.removeFromParent()
    }
    var scene:SceneComponentDelegate?
    var healtComponent:HealthComponent?{ return entity?.component(ofType: HealthComponent.self) }
}
let textures:[EntityType:SKTexture] = [
    EntityType.Triange:SKTexture(imageNamed: "triangle.png"),
    EntityType.Square:SKTexture(imageNamed: "square.png"),
    EntityType.Circle:SKTexture(imageNamed: "tank.png")
]
enum EntityType {
    case Triange
    case Square
    case Circle
}

let TANKZBUFFER:CGFloat = 0
let TURRETZBUFFER:CGFloat = -10
let BULLETZBUFFER:CGFloat = 20

let fireAction:SKAction = SKAction.sequence([
	.scaleX(to: 0.9, y: 1, duration: 0.1),
	.scaleX(to: 1.0, y: 1, duration: 0.1),
	])

let hurtAction:SKAction = SKAction.sequence([
	SKAction.colorize(with: NSColor.red, colorBlendFactor: 0.5, duration: 0.05),
	SKAction.colorize(withColorBlendFactor: 0, duration: 0.05)
	])
//	SKAction.sequence([
//	SKAction.customAction(withDuration: 1, actionBlock: {
//		node, elapsedTime in
//		if let node = node as? SKSpriteNode{
//			SKSpriteNode().
//		}
//	})
//	])

func getFoodPath(_ foodType:FoodType, size:CGFloat) -> CGPath{
	switch foodType {
	case .Square:
		let path = NSBezierPath()
		path.move(to: NSPoint(x: 0, y: 0))
		path.line(to: NSPoint(x: 0, y: 2*size))
		path.line(to: NSPoint(x: 2*size, y: 2*size))
		path.line(to: NSPoint(x: 2*size, y: 0))
		path.line(to: NSPoint(x: 0, y: 0))
		path.close()
		return path.cgPath
	case .Triangle:
		let path = NSBezierPath()
		path.move(to: NSPoint(x: 0, y: 0))
		path.line(to: NSPoint(x: size / 2 * root3, y: size + size/2))
		path.line(to: NSPoint(x: size * root3, y: 0))
		path.line(to: NSPoint(x: 0, y: 0))
		path.close()
		return path.cgPath
	}
}

var root3:CGFloat = CGFloat(3).squareRoot()
let foodColors:[FoodType:(fill:NSColor, stroke:NSColor)] = [
	.Triangle:(fill:NSColor(red:0.99, green:0.46, blue:0.46, alpha:1.0), stroke:NSColor(red:0.32, green:0.32, blue:0.32, alpha:1.0)),
	.Square:(fill:NSColor(red:1.00, green:0.89, blue:0.42, alpha:1.0), stroke:NSColor(red:0.32, green:0.32, blue:0.32, alpha:1.0)),
]
