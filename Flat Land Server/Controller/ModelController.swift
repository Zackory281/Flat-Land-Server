//
//  ModelController.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/17/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation

class ArenaModelController {
    
    var arenaModel:ArenaModel
    var serverController:ServerModelController
    
    init?(size:CGSize)throws{
        self.arenaModel = ArenaModel(size: size)
        serverController = ServerModelController()!
    }
    
    func startServer() {
        serverController.startServer()
    }
}
