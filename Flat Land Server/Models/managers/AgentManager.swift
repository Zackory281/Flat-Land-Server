//
//  AgentManager.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/16/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class AgentManager {
    var agents = Set<GKAgent2D>()
    var components = Set<AgentComponent>()
    var targetAgent = GKAgent2D()
    init() {}
    func addEntity(entity:GKEntity) -> Void {
        guard let agent = entity.component(ofType: AgentComponent.self)?.agent else { return }
        agents.insert(agent)
        components.insert(entity.component(ofType: AgentComponent.self)!)
    }
    func removeEntity(entity:GKEntity) {
        guard let agent = entity.component(ofType: AgentComponent.self)?.agent else { return }
        agents.remove(agent)
        components.remove(entity.component(ofType: AgentComponent.self)!)
    }
    func seekLocation(location:float2){
        targetAgent.position = location
        for comp in components{
            comp.addBehavior(.Seek, behavior: GKBehavior(goal: GKGoal.init(toSeekAgent: targetAgent), weight: 1))
        }
    }
}
