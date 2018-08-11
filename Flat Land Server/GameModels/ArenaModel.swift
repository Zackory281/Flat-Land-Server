//
//  ArenaModel.swift
//  Flat Land
//
//  Created by Zackory Cramer on 5/27/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ArenaModel: NSObject, SKSceneDelegate, ArenaDelegate, EntitManagerDelegate, TouchManagerDelegate, TurretManagerDelegate, PhysicsManagerDelegate, ArenaSceneTouchDelegate{
    func makeAllTankGo(direction: Direction?) {
        componentManager.getEntitiesOf(type: ShapeTankEntity.self).forEach{ tank in
            tank.direction = direction
        }
    }
    var delegate:ArenaDelegate?
    let scene:ArenaScene!
    var lastTime:TimeInterval?
    //class managers
    var componentManager:ComponentManager!
    var sceneManager:SceneManager!
    var touchManager:TouchManager!
    var turretManager:TurretManager!
    var physicsManager:PhysicsManager!
    var mapManager:MapManager!
    var agentManager:AgentManager!
    //class objects
    var entities:SetPointer<GKEntity>
    lazy var arenaDelegate:ArenaDelegate = {return self}()
    //class objects end
    var debugNode:SKNode?
    init(size:CGSize) {
        self.scene = ArenaScene(size: size)
        entities = SetPointer<GKEntity>()
        super.init()
        componentManager = ComponentManager(entities: entities)
        sceneManager = SceneManager(scene: scene)
        touchManager = TouchManager(touchManagerDelegate: self, scene: scene, entities: entities)
        turretManager = TurretManager(turretManagerDelegate:self)
        physicsManager = PhysicsManager(physicsWorld: scene.physicsWorld, delegate:self)
        mapManager = MapManager()
        agentManager = AgentManager()
        scene.clickDelegate = self
        
        self.initiateSceneComp()
        scene.delegate = self
        
        initiateDebugEntities()
        initiateButtons()
        initiateBuildings()
		scene.dummy = self.addControllableEntity()
    }
    func addEntity(entity:GKEntity){
        componentManager.addEntity(entity: entity)
        mapManager.addEntity(entity: entity)
        agentManager.addEntity(entity: entity)
    }
    func removeEntity(entity:GKEntity) {
        componentManager.delete(entity: entity)
        mapManager.removeEntity(entity: entity)
        agentManager.removeEntity(entity: entity)
    }
    func removeAllEntity<T:GKEntity>(_ type:T.Type){
        for toRemove in componentManager.getEntitiesOf(type: type){
            removeEntity(entity: toRemove)
        }
    }
    func addBullet(bullet:Bullet) {
        addEntity(entity: BulletEntity(bullet: bullet, scene: sceneManager, arena: arenaDelegate))
    }
    func doAction(action:ArenaAction, location:CGPoint?){
        switch action {
        case ArenaAction.DropEntity:
            let shapeEntity = ShapeTankEntity(type: .Circle,position:location!, scene:self.sceneManager, turretDelegate:turretManager, map:self.mapManager, arena:self)
            self.addEntity(entity: shapeEntity)
        case ArenaAction.AddBui:
            let buildingEntity = BuildingEntity(building: .getBuilding(location!.x, location!.y), scene: sceneManager, arena:self)
            self.addEntity(entity: buildingEntity)
            break
        case .Flock:
            agentManager.seekLocation(location: toVector_2f(location!))
            break
        case .Remove:
            removeAllEntity(ShapeTankEntity.self)
            break
        default:
            break;
        }
    }
    func getEntityOfBody<T>(body: SKPhysicsBody, type: T.Type) -> T? {
        let ent = componentManager.entities.set.first{ entity in
            if let _ = entity as? T{
                if let body2 = entity.component(ofType: PhysicsComponent.self)?.physicsBody{
                    return body2 == body
                }
            }
            return false
        }
        return ent as? T
    }
    func clicked(point:CGPoint) -> Void {
        touchManager.touched(point: point)
    }
    func goDirection(){
        
    }
    func announceInOverlay(_ text: String) {
        //print("to announce\(text)")
    }
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        guard scene == self.scene else {print("not my business"); return;}
        guard let _ = lastTime else { lastTime = currentTime; return;}
        componentManager.update(currentTime - lastTime!)
        lastTime = currentTime
    }
}
protocol ArenaDelegate {
    func removeEntity(entity:GKEntity)
}
enum ArenaAction:String{
    case DropEntity = "drop"
    case AddBui = "add building"
    case Act = "Act"
    case Flock = "Flock"
    case Remove = "Remove"
}
extension ArenaModel{
    func initiateDebugEntities(){
        self.addEntity(entity: ShapeTankEntity(type: .Circle,position:CGPoint.init(x: 100, y: 100), scene:self.sceneManager, turretDelegate:turretManager, map:self.mapManager, arena:self))
    }
    func initiateSceneComp(){
    }
    func initiateBuildings(){
        addEntity(entity: BuildingEntity(building: Building.getBuilding(300, 300), scene: sceneManager, arena:self))
    }
    func initiateButtons(){
        addEntity(entity: ButtonEntity(10,10,100,100,action: ArenaAction.DropEntity, scene:sceneManager))
        addEntity(entity: ButtonEntity(10,120,100,100,action: ArenaAction.AddBui, scene:sceneManager))
        addEntity(entity: ButtonEntity(10,230,100,100,action: ArenaAction.Flock, scene:sceneManager))
        addEntity(entity: ButtonEntity(10,340,100,100,action: ArenaAction.Remove, scene:sceneManager))
    }
}
extension ArenaModel{//ModelController extension
    func addControllableEntity() -> Controllable {
        let entity = ShapeTankEntity(type: .Circle,position:CGPoint.init(x: 100, y: 120), scene:self.sceneManager, turretDelegate:turretManager, map:self.mapManager, arena:self)
        self.addEntity(entity: entity)
        return entity
    }
}
