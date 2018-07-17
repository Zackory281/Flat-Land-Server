//
//  Server.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/13/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation
import Socket

class Server {
    
    var socket:Socket!
    var listeningQueue = DispatchQueue(label: "listener")
    var active = true
    var port:Int
    init() {
        do{
            try self.socket = Socket.create(family: .inet, type: .datagram, proto: .udp)
        }catch{
            print(error)
        }
    }
    
    func startListening(){
        listeningQueue.sync {
            var readData = Data(capacity: BUFFER_SIZE)
            repeat{
                self.socket.listen(forMessage: &readData, on: port)
                self.socket.write
            }while active
        }
    }
}

let BUFFER_SIZE = 8096
