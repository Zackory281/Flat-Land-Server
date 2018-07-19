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
    var delegate:PlayerModelControllerDelegate?
    init() {
        
    }
    
    func addPlayer(address:Socket.Address, name:String="An unnamed Lucy") {
        guard let playerKey = getAddressKey(address: address), !players.keys.contains(playerKey) else {print("not adding an existing player"); return;}
        guard let controllable = delegate?.getNewPlayerEntity() else { print("Player model controller delegate not set, can't create new entity."); return;}
        let newPlayer = Player(address: address, name: name, controllable: controllable)
        self.players[playerKey] = newPlayer
        print("added player: \(playerKey), \(name)")
    }
    
    func updatePlayer(address:Socket.Address, direction:ControlDirection, fire:Bool, angle:Float32){
        guard let playerKey = getAddressKey(address: address) else {print("updating player with bad address key"); return;}
        guard let player = players[playerKey] else { print("player with key \(playerKey) doesn't exit, can't update it"); return;}
        player.move(direction)
    }
}

protocol PlayerModelControllerDelegate {
    func getNewPlayerEntity()->Controllable
}

class Player{
    let address:Socket.Address
    let name:String
    private weak var controllable:Controllable?
    init(address:Socket.Address, name:String, controllable:Controllable) {
        self.address = address
        self.name = name
        self.controllable = controllable
    }
    
    func move(_ direction:ControlDirection) -> Void {
        guard let controllable = self.controllable else {
            print("contorllable doesn't exist, can't control it");
            return;
        }
        guard let move = controllable.move else {
            print("contorllable can't be moved");
            return;
        }
        switch direction {
        case DOWN:
            move(CGVector(dx: 0, dy: -20))
        case UP:
            move(CGVector(dx: 0, dy: 20))
        case RIGHT:
            print("going RIGHT")
        case LEFT:
            print("going RIGHT")
        default:
            print("wht?")
        }
    }
}

func getAddressKey(address: Socket.Address) -> String?{
    guard let info = Socket.hostnameAndPort(from: address) else {return nil}
    return info.hostname+":"+String(info.port)
}
