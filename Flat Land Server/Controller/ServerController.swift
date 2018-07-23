//
//  ServerController.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/17/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation
import Compression
import Socket


class ServerModelController:ServerDelegate{
    
    let server:Server
    let encoder:JSONEncoder = JSONEncoder()
    let decoder:JSONDecoder = JSONDecoder()
    var delegate:ServerControllerDelegate?
    
    init?() {
        do{
            try self.server = Server()
        }catch{
            print("error initiating server: \(error)")
            do{
                try self.server = Server()
            }catch{
                print("error initiating server: \(error)")
                return nil
            }
        }
        server.delegate = self
    }
    
    func processPayLoad(_ packet:PlayerPacket, _ info:MessageInfo){
        guard let delegate = self.delegate else { print("server delegate not set"); return}
        let opcode = packet.initPacket.opcode
        switch Int32(opcode) {
        case Init_opcode:
            delegate.addPlayer(playerInit: packet.initPacket, address: info.address!)
        case Update_opcode:
            delegate.updatePlayer(playerControl: packet.controlPacket, address: info.address!)
        case Check_opcode:
            sendConnectionCheckPack(hash: packet.connectionCheckPacket.hash, address: info.address!)
        default:
            print("not a recognized opcode: \(opcode)")
        }
    }
    
    
    func sendConnectionCheckPack(hash:Int32, address:Socket.Address){
        let checkPacketPtr = getCheckPacket(hash)
        server.writeData(Data(bytes: checkPacketPtr!, count: MemoryLayout<PlayerConnectionCheckPacket>.size), address: address)
        free(checkPacketPtr)
    }
    
    func receiveData(data:Data, messageInfo:MessageInfo){
        //print(Socket.hostnameAndPort(from:messageInfo.address!))
        data.withUnsafeBytes { (pointer:UnsafePointer<PlayerPacket>) in
            processPayLoad(pointer.pointee, messageInfo)
        }
    }
    
    func startServer() {
        server.startListening()
    }
}

protocol ServerControllerDelegate {
    func updatePlayer(playerControl:PlayerControlPacket, address: Socket.Address)
    func addPlayer(playerInit:PlayerInitPacket, address:Socket.Address)
}
struct PlayerRequest:Codable {
    var keys:[String]?
    var angle:Float?
    var fire:Bool?
}

