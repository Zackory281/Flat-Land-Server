//
//  AgentComponent.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/15/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class AgentComponent:GKComponent,GKAgentDelegate{
    let agent = GKAgent2D()
    var behaviors:[AgentBehaviors:GKBehavior] = [AgentBehaviors:GKBehavior]()
    func addBehavior(_ behaviorsType:AgentBehaviors, behavior:GKBehavior, calibrate:Bool = true){
        behaviors[behaviorsType] = behavior
        if calibrate{calibrateBehavior()}
    }
    func calibrateBehavior(){
        let behaviors:[GKBehavior] = self.behaviors.map{return $1}
        let behavior = GKCompositeBehavior(behaviors: behaviors)
        self.agent.behavior = behavior
    }
    func removeGoals(){
        behaviors.removeAll()
    }
    override init() {
        super.init()
        agent.delegate = self
        self.agent.maxSpeed = 400
        self.agent.maxAcceleration = 4000
        self.agent.mass = 0.1
        self.agent.radius = 50
        self.agent.behavior = GKBehavior(goal: GKGoal.init(toWander: 100), weight: 1)
    }
    override func update(deltaTime seconds: TimeInterval) {
        agent.update(deltaTime: seconds)
    }
    func agentWillUpdate(_ agent: GKAgent) {
        guard let _ = position else {return}
        self.agent.position = position!
        self.agent.rotation = rotation
    }
    func agentDidUpdate(_ agent: GKAgent) {
        guard let body = self.physicsNode, let pos = self.position else { return }
        let dx = Double(self.agent.position.x - pos.x)
        let dy = Double(self.agent.position.y - pos.y)
        let da = CGFloat(self.agent.rotation - rotation)
        body.applyImpulse(CGVector(dx: dx*60, dy: dy*60))
        //body.applyTorque(da)
        //self.position = self.agent.position
        //agRot = self.agent.rotation
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var position:vector_float2?{
        get{
            guard let pos = entity!.component(ofType: SpriteComponent.self)?.spriteNode.position else {return nil}
            return vector_float2(Float(pos.x), Float(pos.y))}
        set{entity!.component(ofType: SpriteComponent.self)?.spriteNode.position = CGPoint(x:CGFloat(newValue!.x), y:CGFloat(newValue!.y))}
    }
    var rotation:Float{ return Float(self.entity?.component(ofType: SpriteComponent.self)?.spriteNode.zRotation ?? 0)}
    var physicsNode:SKPhysicsBody?{ return entity?.component(ofType: PhysicsComponent.self)?.physicsBody}
}
enum AgentBehaviors {
    case Seek
    case FollowPath
    case Flock
    case ToSpeed
}
