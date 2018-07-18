//
//  Server.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/13/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation
import SpriteKit
import Socket

typealias MessageInfo = (bytesRead: Int, address: Socket.Address?)
class Server{
    
    var socket:Socket!
    var listeningQueue = DispatchQueue(label: "listener", attributes: .concurrent)
    var active = true
    var port:Int
    var delegate:ServerDelegate?
    init(port:Int=8080)throws{
        self.port = port
        try self.socket = Socket.create(family: .inet, type: .datagram, proto: .udp)
        try self.socket.udpBroadcast(enable: true)
    }
    
    func startListening(){
        listeningQueue.async { [unowned self] in
            var readData = Data(capacity: BUFFER_SIZE)
            repeat{
                do {
                    let messageInfo = try self.socket.listen(forMessage: &readData, on: self.port)
                    self.recieveData(readData, messageInfo)
                } catch {
                    print("failed to read data\(error)")
                }
                readData.count = 0
            }while self.active
        }
    }
    
    func sendData(_ data:Data){
        do{
            print(String(data:data, encoding:.utf8))
            //try socket.write(from: data, to: Socket.createAddress(for: "localhost", on: Int32(port))!)
        }catch{
            print("failed to print \(data) \(error)")
        }
    }
    
    func recieveData(_ data:Data, _ info:MessageInfo){
        delegate?.receiveData(data: data)
        do{
            try self.socket.write(from: "I repeat \(String(data:data, encoding:.utf8) ?? "ur message was poop")", to: info.address!)
        }catch{
            print("error echoing \(error)")
        }
    }
}

@objc protocol ServerDelegate{
    @objc optional func receiveMessage(message:String);
    func receiveData(data:Data);
}


let BUFFER_SIZE = 8096
