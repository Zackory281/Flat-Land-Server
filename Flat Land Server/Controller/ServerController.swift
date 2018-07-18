//
//  ServerController.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/17/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation

class ServerModelController:ServerDelegate {
    
    let server:Server
    let encoder:JSONEncoder = JSONEncoder()
    let decoder:JSONDecoder = JSONDecoder()
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
    
    func receiveData(data:Data){
        do{
            let ha = PlayerRequest(directions: ["Lucy", "Zack", "Jero"], angle: 1.999, fire: true)
            let endata = try encoder.encode(ha)
            server.sendData(endata)
            let json = try JSONDecoder().decode(PlayerRequest.self, from: endata)
            print(json)
        }catch{
            print("received data from server controller: \(data)")
        }
    }
    
    func startServer() {
        server.startListening()
    }
}
struct PlayerRequest:Codable {
    var directions:[String]?
    var angle:Float?
    var fire:Bool?
}

