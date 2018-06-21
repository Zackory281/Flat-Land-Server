//
//  TouchManager.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/15/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class TouchManager:NSObject{
    var toPerformAction:ArenaAction?
    /*func touched(touch:UITouch){
        let node = scene.atPoint(touch.location(in: scene))
        if let pressedButton = entities.set.first(where: {entity in
            guard let buttonNode = (entity as? ButtonEntity)?.node else { return false}
            return (node.inParentHierarchy(buttonNode) || node == buttonNode)
        }){
            select(action: (pressedButton as! ButtonEntity).action , touch.location(in: scene))
        }else{
            select(action: .Act, touch.location(in: scene))
        }
    }*/
    func select(action:ArenaAction, _ touch:CGPoint){
        touchManagerDelegate.announceInOverlay(action.rawValue)
        switch action {
        case .Act:
            guard let select = toPerformAction else { return }
            touchManagerDelegate.doAction(action: select, location: touch)
        case .Remove:
            touchManagerDelegate.doAction(action: action, location: touch)
        default:
            toPerformAction = action
        }
    }
    init(touchManagerDelegate:TouchManagerDelegate, scene:SKScene, entities:SetPointer<GKEntity>) {
        self.touchManagerDelegate = touchManagerDelegate
        self.scene = scene
        self.entities = entities
    }
    enum TouchAction {
        case Select(action:String,position:CGPoint)
        case Act
    }
    let touchManagerDelegate:TouchManagerDelegate
    var scene:SKScene
    var entities:SetPointer<GKEntity>
}
protocol TouchManagerDelegate {
    func announceInOverlay(_ text:String)
    func doAction(action:ArenaAction,location:CGPoint?)
}
