//
//  ModelController.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/17/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation
import Socket

class ArenaModelController:ServerControllerDelegate {
    
    var arenaModel:ArenaModel
    var serverController:ServerModelController
    var playerController:PlayerModelController
    var players = Dictionary<String, Player>()
    
    func addPlayer(playerInit: PlayerInitPacket, address: Socket.Address) {
        let ptr = getPlayerName(playerInit)!
        let name = String(cString: ptr)
        free(ptr)
        playerController.addPlayer(address: address, name: name)
    }
    
    func updatePlayer(playerControl: PlayerControlPacket, address: Socket.Address) {
        
    }
    
    init?(size:CGSize)throws{
        self.arenaModel = ArenaModel(size: size)
        serverController = ServerModelController()!
        playerController = PlayerModelController()
        serverController.delegate = self
    }
    
    func startServer() {
        serverController.startServer()
    }
}
