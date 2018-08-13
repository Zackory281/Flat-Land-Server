//
//  ShapeEntity.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/15/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class ShapeEntity:GKEntity{
    var positon:CGPoint{
        get{return self.component(ofType: SpriteComponent.self)!.spriteNode.position}
        set{self.component(ofType: SpriteComponent.self)!.spriteNode.position = newValue}
    }
    var spriteComponent:SpriteComponent{ return self.component(ofType: SpriteComponent.self)!}
    var agentComponent:AgentComponent{ return self.component(ofType: AgentComponent.self)!}
    var debugNode:SKNode?
    var pathNode:SKShapeNode?
    var maxSpeed:Float = 20
    
    var scene:SceneComponentDelegate?
    // State Machine Stuff
    var stateMachine:GKStateMachine!
    var targetAgent:GKAgent2D?
    var flockAgents:[GKAgent2D]?
    //Actual Entity Stuff
    var tank:Tank
    init(tankEntity:Tank, scene:SceneComponentDelegate?=nil) {
        self.tank = tankEntity
        super.init()
        self.scene = scene
        stateMachine = GKStateMachine(states: [
            ShapeIdleState(entity: self),
            ShapeMovingState(entity: self),
            ShapeReachAgentState(entity: self),
            ])
        addComponent(SpriteComponent(tank: tankEntity, scene:scene))
        addComponent(AgentComponent())
    }
    convenience init(scene:SceneComponentDelegate?=nil){
        self.init(tankEntity: getTank(type: .twin), scene:scene)
    }
    func goHere(target targetAgent:GKAgent2D, agents flockingAgents:[GKAgent2D]=[])
    {
        self.targetAgent = targetAgent
        self.flockAgents = flockingAgents
        stateMachine.enter(ShapeReachAgentState.self)
    }
    override func update(deltaTime seconds: TimeInterval) {
        stateMachine.update(deltaTime: seconds)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func followPath(path:GKPath,graphNodes:[GKGraphNode2D]=[]){
        stayOnPath(path: path)
    }
    func seekAgent(agent:GKAgent2D){
        agentComponent.addBehavior(.Seek, behavior: GKBehavior(goal: GKGoal(toSeekAgent: agent), weight: 0.1))
    }
    func stayOnPath(path:GKPath){
        agentComponent.addBehavior(.FollowPath, behavior: GKBehavior(goal: GKGoal.init(toStayOn: path, maxPredictionTime: 1), weight: 1))
        agentComponent.addBehavior(.ToSpeed, behavior: GKBehavior.init(goal: GKGoal.init(toReachTargetSpeed: maxSpeed), weight: 1))
    }
    func flock(agents:[GKAgent]){
        let separateGoal = GKGoal(toSeparateFrom: agents, maxDistance: 10, maxAngle: .pi/4)
        //let cohereGoal = GKGoal(toCohereWith: agents, maxDistance: 10, maxAngle: .pi/4)
        //let alignGoal = GKGoal(toAlignWith: agents, maxDistance: 10, maxAngle: .pi/4)
        agentComponent.addBehavior(.Flock, behavior: GKBehavior(goals: [separateGoal]))
    }
}
