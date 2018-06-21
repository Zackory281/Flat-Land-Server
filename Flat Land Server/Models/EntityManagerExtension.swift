//
//  ArenaExtension.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/10/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

extension ComponentManager{
    func perSystem(_ function:(GKComponentSystem<GKComponent>)->()){for system in componentSystem{function(system)}}
    func perComponent(_ function:(GKComponent)->() ){for system in componentSystem{for component in system.components{function(component)}}}
    func perEntity(_ function:(GKEntity)->()){
        for entity in entitiesSet{
            function(entity)
        }
    }
    func perEntity<T>(_ function:(T)->(),type: T.Type ){for entity in entitiesSet{if let entity = entity as? T{function(entity)}}}
    func getEntitiesOf<T:GKEntity>(type:T.Type) -> Set<T>{
        return entitiesSet.filter{entity in
            if let _ = entity as? T{
                return true
            }
            return false
            } as! Set<T>
    }
//    func getFlockGroup<T>(_ type:T.Type, entities:inout Set<GKEntity>) -> [T] {
//        var group:[T] = []
//        self.perEntity({entity in
//            group.append(entity)
//        }, type: T.self)
//        return group
//    }
}
