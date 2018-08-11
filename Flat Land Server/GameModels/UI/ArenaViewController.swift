//
//  ViewController.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 6/20/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ArenaViewController: NSViewController {
    
    @IBOutlet var skView: SKView!
    var gameModelController:ArenaModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func presentScene(){
        if let view = self.skView {
            view.presentScene(gameModelController.arenaModel.scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
			//view.showsPhysics = true
        }
    }
}

