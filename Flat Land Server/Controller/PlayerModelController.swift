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
    
    func updatePlayer(address:Socket.Address, dx:Float, dy:Float, fire:Bool, angle:Float32){
        guard let playerKey = getAddressKey(address: address) else {print("updating player with bad address key"); return;}
        guard let player = players[playerKey] else { print("player with key \(playerKey) doesn't exit, can't update it"); return;}
        player.move(CGVector(dx: CGFloat(dx), dy: CGFloat(dy)))
        //print("\(dx), \(dy)")
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
    
    func move(_ unit:CGVector) -> Void {
        guard let controllable = self.controllable else {
            print("contorllable doesn't exist, can't control it");
            return;
        }
        guard let move = controllable.move else {
            print("contorllable can't be moved");
            return;
        }
        move(unit * 200)
    }
}

func getAddressKey(address: Socket.Address) -> String?{
    guard let info = Socket.hostnameAndPort(from: address) else {return nil}
    return info.hostname+":"+String(info.port)
}
