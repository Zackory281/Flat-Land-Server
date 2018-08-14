//
//  SceneManager.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/15/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class SceneManager:SceneComponentDelegate{
	func getTexture(node: SKShapeNode) -> SKTexture {
		//guard let view = scene?.view else {return nil}
		return scene!.view!.texture(from: node)!
	}
	
    func addNode(node: SKNode) {
        scene?.addChild(node)
        //scene.addChild(SKLabelNode(attributedText: NSAttributedString(string: "hello world")))
    }
    func removeNode(node:SKNode){
        node.removeFromParent()
    }
    weak var scene:SKScene?
    init(scene:SKScene) {
        self.scene = scene
        self.scene?.backgroundColor = NSColor.white
    }
}

protocol SceneComponentDelegate {
    func addNode(node:SKNode)
	func getTexture(node:SKShapeNode) -> SKTexture
}
