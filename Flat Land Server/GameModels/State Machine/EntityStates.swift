//
//  EntityStates.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/14/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class ShapeIdleState:GKState{
    weak var entity:ShapeEntity?
    init(entity:ShapeEntity) {
        self.entity = entity
        super.init()
    }
    override func update(deltaTime seconds: TimeInterval) {
        guard let entity = entity else { return }
        print("idle")
    }
}
class ShapeMovingState:GKState{
    weak var entity:ShapeEntity?
    init(entity:ShapeEntity) {
        self.entity = entity
        super.init()
    }
    override func update(deltaTime seconds: TimeInterval) {
        guard let entity = entity else { return }
        print("moving")
    }
}
class ShapeReachAgentState:GKState{
    weak var entity:ShapeEntity?
    init(entity:ShapeEntity) {
        self.entity = entity
        super.init()
    }
    override func didEnter(from previousState: GKState?) {
        guard let entity = entity else { return }
        entity.flock(agents: entity.flockAgents!)
        entity.seekAgent(agent: entity.targetAgent!)
    }
    override func update(deltaTime seconds: TimeInterval) {
        //print("moving")
    }
}
