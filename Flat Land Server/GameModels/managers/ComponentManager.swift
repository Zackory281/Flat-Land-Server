//
//  EntityManager.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/14/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class ComponentManager{
    var toRemove = Set<GKEntity>()
    var entities:SetPointer<GKEntity>
    var entitiesSet:Set<GKEntity>{ return entities.set }
    var componentSystem:[GKComponentSystem<GKComponent>] = [
        GKComponentSystem(componentClass: SpriteComponent.self),
        GKComponentSystem(componentClass: HealthComponent.self),
        GKComponentSystem(componentClass: AgentComponent.self),
        GKComponentSystem(componentClass: TurretComponent.self),
        GKComponentSystem(componentClass: DisappearComponent.self),
		GKComponentSystem(componentClass: PhysicsComponent.self),]
    init(entities:SetPointer<GKEntity>) {
        self.entities = entities
    }
    func addEntity(entity:GKEntity ) {
        entities.insert(entity)
        perSystem({ system in
            system.addComponent(foundIn: entity)
        })
    }
    func update(_ delta:TimeInterval ){
        //removing comonents
        for entity in toRemove{
            entities.remove(entity)
            perSystem({system in
                system.removeComponent(foundIn: entity)
            })
        }
        toRemove.removeAll()
        //updating components
        perSystem{
            $0.update(deltaTime: delta)
        }
        perEntity(){
            $0.update(deltaTime: delta)
        }
    }
    func delete(entity:GKEntity) -> Void {toRemove.insert(entity)}
    func removeAll(){
        toRemove = entities.set.filter{ entity in
            return (entity as? ShapeEntity) != nil
        }
    }
    func makeFlockGoHere<T>(entities:T.Type, location:CGPoint){
        let objectiveEntities:Set<ShapeEntity> = self.getEntitiesOf(type: ShapeEntity.self)
        let agents = objectiveEntities.map{$0.agentComponent.agent}
        let agent = GKAgent2D()
        agent.position = toVector_2f(location)
        objectiveEntities.forEach{ entity in
            entity.goHere(target: agent, agents: agents)
        }
    }
}
class SetPointer<T:Hashable>{
    var set:Set<T>
    init() {
        set = Set<T>()
    }
    func insert(_ entity:T) {
        set.insert(entity)
    }
    func remove(_ entity:T) {
        set.remove(entity)
    }
}
protocol EntitManagerDelegate {
    
}
