//
//  Entites.swift
//  Flat Land
//
//  Created by Zackory Cramer on 5/28/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class ButtonEntity:GKEntity{
    var label:String{ return action.rawValue }
    let action:ArenaAction
    var node:SKNode{
        return component(ofType: SpriteComponent.self)!.spriteNode
    }
    var scene:SceneComponentDelegate?
    init(_ x:Int,_ y:Int,_ width:Int,_ height:Int,action:ArenaAction, scene:SceneComponentDelegate?=nil) {
        self.action = action
        self.scene = scene
        super.init()
        addComponent(SpriteComponent(x,y,width,height,label:label, scene:scene))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public func toCGPoint(_ pos:vector_float2) -> CGPoint{
    return CGPoint(x: CGFloat(pos.x), y: CGFloat(pos.y))
}

public func toVector_2f(_ point:CGPoint) -> vector_float2{
    return vector_float2(Float(point.x), Float(point.y))
}
