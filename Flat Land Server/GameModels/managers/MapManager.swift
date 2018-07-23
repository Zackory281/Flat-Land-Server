//
//  MapManager.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/16/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class MapManager: MapComponentDelegate {
    
    var entities:Set<BuildingEntity> = []
    var quadTree:GKQuadtree = GKQuadtree(boundingQuad: GKQuad.init(quadMin: float2(0,0), quadMax: float2(3000,3000)), minimumCellSize: 0.1)
    func getAim(from position:float2, maxDistance:Float) -> AimIntel? {
        let bound = getBoudingQuad(center: position, radius: maxDistance)
        let closest = quadTree.elements(in: bound).min(by: {(entity1, entity2) in
            return distance((entity1 as! BuildingEntity).position, position) < distance((entity2 as! BuildingEntity).position, position)
        })
        return AimIntel(closestEntity: closest as? BuildingEntity)
    }
    func addEntity(entity:GKEntity){
        guard let entity = entity as? BuildingEntity else { return }
        quadTree.add(entity, at: toVector_2f(entity.building.position))
    }
    func removeEntity(entity:GKEntity){
        guard let entity = entity as? BuildingEntity else { return }
        quadTree.remove(entity)
    }
    func getBoudingQuad(center:float2, radius:Float) -> GKQuad{
        return GKQuad(quadMin: float2(center.x-radius/2,center.y-radius/2), quadMax: float2(center.x+radius/2,center.y+radius/2))
    }
}

protocol MapComponentDelegate {
    func getAim(from position:float2, maxDistance:Float) -> AimIntel?;
}

struct AimIntel {
    var closestEntity:BuildingEntity?
    init(closestEntity:BuildingEntity?) {
        self.closestEntity = closestEntity
    }
}
