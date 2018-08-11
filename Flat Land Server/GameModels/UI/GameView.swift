//
//  GameView.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 8/10/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

import Foundation
import Cocoa
import GameplayKit

class ArenaView:SKView{
	override func viewDidMoveToWindow() {
		let options = [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow] as NSTrackingArea.Options
		let trackingArea = NSTrackingArea(rect:self.frame,options:options,owner:self,userInfo:nil)
		self.addTrackingArea(trackingArea)
	}
}
