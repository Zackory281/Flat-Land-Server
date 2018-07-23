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
typealias HostPortInfo = (hostname: String, port: Int32)

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
    
    func recieveData(_ data:Data, _ info:MessageInfo){
        delegate?.receiveData(data: data, messageInfo: info)
        do{
            try self.socket.write(from: "I repeat \(String(data:data, encoding:.utf8) ?? "ur message was poop")", to: info.address!)
        }catch{
            print("error echoing \(error)")
        }
    }
    
    func writeData(_ data:Data, address:Socket.Address){
        do{
            try socket!.write(from: data, to: address)
            print("written \(data) bytes to \(getHostDataString(address))")
        }catch{
            print("failed to write data\(data) to add\(getHostDataString(address)))")
        }
    }
}

func getHostDataString(_ address:Socket.Address) -> String{
    return String(describing: Socket.hostnameAndPort(from: address))
}

protocol ServerDelegate{
    func receiveData(data:Data,messageInfo:MessageInfo);
}


let BUFFER_SIZE = 8096
