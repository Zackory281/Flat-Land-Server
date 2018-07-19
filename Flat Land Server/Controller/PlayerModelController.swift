//
//  PlayerModelController.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/17/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation
import Socket

class PlayerModelController{
    var players = Dictionary<String, Player>()
    init() {
        
    }
    
    func addPlayer(address:Socket.Address, name:String="An unnamed Lucy") {
        guard let playerKey = getAddressKey(address: address), !players.keys.contains(playerKey) else {print("not adding an existing player"); return;}
        //players[playerKey] = Player(address: address, name: name)
        print("added player: \(playerKey), \(name)")
    }
    
    func updatePlayer(address:Socket.Address, direction:ControlDirection, fire:Bool, angle:Float32){
        
    }
}

class Player{
    let address:Socket.Address
    let name:String
    var controllable:Controllable?
    init(address:Socket.Address, name:String, controllable:Controllable) {
        self.address = address
        self.name = name
        self.controllable = controllable
    }
}

enum ControlDirection {
    case UP
    case DOWN
    case RIGHT
    case LEFT
}

func getAddressKey(address: Socket.Address) -> String?{
    guard let info = Socket.hostnameAndPort(from: address) else {return nil}
    return info.hostname+":"+String(info.port)
}
