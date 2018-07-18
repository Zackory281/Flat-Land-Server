//
//  PlayerModelController.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/17/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation
import Socket

class PlayerController{
    var players = Set<Player>()
    init() {
        
    }
    
    func addPlayer(address:Socket.Address, name:String="An unnamed Lucy") {
        players.insert(Player(address: address, name: name))
    }
}

class Player:Hashable{
    static func == (lhs: Player, rhs: Player) -> Bool {
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
    
    let address:Socket.Address
    let name:String
    init(address:Socket.Address, name:String) {
        self.address = address
        self.name = name
    }
}
