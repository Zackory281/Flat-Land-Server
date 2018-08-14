//
//  DisappearComponent.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/15/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class DisappearComponent: GKComponent {
    var arena:ArenaDelegate
    var timeOut:TimeInterval
    var shouldDisappear:DisappearFunction
    var passedTime:TimeInterval = 0
	init(function:@escaping DisappearFunction, timeOut:TimeInterval=2, arena:ArenaDelegate) {
        self.shouldDisappear = function
        self.arena = arena
		self.timeOut = timeOut
        super.init()
    }
    override func update(deltaTime seconds: TimeInterval) {
        passedTime += seconds
        if shouldDisappear(entity!) {
            arena.removeEntity(entity: entity!)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

typealias DisappearFunction = (GKEntity)->Bool
