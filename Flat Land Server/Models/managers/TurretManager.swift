//
//  TurretManager.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/15/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import GameplayKit

class TurretManager:TurretDelegate{
    func fire(bullet:Bullet) {
        turretManagerDelegate.addBullet(bullet: bullet)
    }
    var turretManagerDelegate:TurretManagerDelegate
    init(turretManagerDelegate:TurretManagerDelegate) {
        self.turretManagerDelegate = turretManagerDelegate
    }
}
protocol TurretDelegate {
    func fire(bullet:Bullet)
}
protocol TurretManagerDelegate {
    func addBullet(bullet:Bullet)
}
