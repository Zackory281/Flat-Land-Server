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
	var tank:Tank?
    init(polygon:EntityType, scene:SceneComponentDelegate?=nil) {
        spriteNode = SKSpriteNode(texture: textures[polygon]!)
        spriteNode.xScale = 1/6
        spriteNode.yScale = 1/6
        self.scene = scene
        super.init()
    }
    init(tank:Tank, scene:SceneComponentDelegate?=nil) {
        let spriteNode = SKShapeNode(circleOfRadius: tank.size/2)
        spriteNode.fillColor = NSColor(red:0.00, green:0.69, blue:0.88, alpha:1.0)
        spriteNode.strokeColor = NSColor(red:0.32, green:0.32, blue:0.32, alpha:1.0)
        spriteNode.lineWidth = 3
        let turret = tank.turrets
        for turretN in turret{
            let turretNode = SKShapeNode(rect: turretN.getTurretRect())
            turretNode.fillColor = NSColor(red:0.60, green:0.60, blue:0.60, alpha:1.0)
            turretNode.strokeColor = NSColor(red:0.45, green:0.45, blue:0.45, alpha:1.0)
            turretNode.lineWidth = 3
            turretNode.zPosition = -10
			turretNode.zRotation = turretN.rotation
			turretNode.position = turretN.getTurretPosition()
            //let action = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.8), SKAction.scale(to: 2, duration: 0.1), SKAction.scale(to: 1.0, duration: 0.1)]))
            turretN.node = turretNode
            spriteNode.addChild(turretNode)
        }
	  	tank.tankNode = spriteNode
        self.spriteNode = spriteNode
        self.scene = scene
		self.tank = tank
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
        self.spriteNode = circle
        self.scene = scene
        super.init()
    }
	init(foodEntity:FoodEntity, scene:SceneComponentDelegate) {
		self.scene = scene
		self.spriteNode = SKShapeNode(rect: CGRect(x: -15, y: -15, width: 30, height: 30))
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
		if let tank = self.tank{
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

