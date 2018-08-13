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
  func fire(bullet:Bullet, bulletFire:BulletFire) {
    turretManagerDelegate.addBullet(bullet: bullet, bulletFire:bulletFire)
  }
  var turretManagerDelegate:TurretManagerDelegate
  init(turretManagerDelegate:TurretManagerDelegate) {
    self.turretManagerDelegate = turretManagerDelegate
  }
}
protocol TurretDelegate {
  func fire(bullet:Bullet, bulletFire:BulletFire)
}
protocol TurretManagerDelegate {
  func addBullet(bullet:Bullet, bulletFire:BulletFire)
}
