//
//  Util.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/16/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import CoreGraphics
import GameplayKit

extension CGPoint{
    static func -(lhs:CGPoint,rhs:CGPoint)->CGVector{
        return CGVector(dx:lhs.x-rhs.x, dy:lhs.y-rhs.y)
    }
    static func +(lhs:CGPoint,rhs:CGPoint)->CGPoint{
        return CGPoint(x:lhs.x+rhs.x, y:lhs.y+rhs.y)
    }
	static func *(lhs:CGPoint,rhs:CGFloat)->CGPoint{
		return CGPoint(x:lhs.x*rhs, y:lhs.y*rhs)
	}
    static func getAngle(_ vector : CGVector)->CGFloat{
		if vector.dx < 0 {
			return CGFloat.pi + (atan(vector.dy/vector.dx))
		}
        return (atan(vector.dy/vector.dx))
    }
	static func getAngle(_ point:CGPoint)->CGFloat{
		if point.x < 0{
			print("is negative")
			return atan2(point.y, point.x) * (CGFloat(-180.0) / CGFloat.pi);
		}
		return atan2(point.y, point.x) * (CGFloat(180.0) / CGFloat.pi);
	}
}

extension CGVector{
    static func normalize(vector:CGVector)->CGVector{
        let length = CGFloat.squareRoot(vector.dx*vector.dx + vector.dy*vector.dy)()
        let result = CGVector(dx: vector.dx/length, dy: vector.dy/length)
        return result
    }
    static func *(lhs:CGVector, rhs:CGFloat)->CGVector{
        return CGVector(dx: lhs.dx*rhs, dy: lhs.dy*rhs)
    }
	static func +(lhs:CGVector, rhs:CGVector)->CGVector{
		return CGVector(dx: lhs.dx+rhs.dx, dy: lhs.dy+rhs.dy)
	}
	static func -(lhs:CGVector, rhs:CGVector)->CGVector{
		return CGVector(dx: lhs.dx-rhs.dx, dy: lhs.dy-rhs.dy)
	}
}
extension UInt32{
    static func shift(_ amount:UInt32)-> UInt32{
        guard amount < 32 else { return UInt32(0) }
        return UInt32(1 << amount)
    }
    static func fill(_ amount:UInt32)-> UInt32{
        return UInt32(UInt64(1 << (amount)) - 1)
    }
}

func getRandomVector(_ velocity:CGFloat=1) -> CGVector{
	let angle = getRandomAngle()
	return CGVector(dx: cos(angle), dy: sin(angle)) * velocity
}
func getRandomAngle() -> CGFloat {
	return CGFloat(GKRandomSource().nextInt(upperBound: 628)) / 100
}
func getRandomDouble() -> CGFloat {
	return CGFloat(GKRandomSource().nextInt(upperBound: 100)) / 100
}

class WeakSet<T> {
	
	var count: Int {
		return weakStorage.count
	}
	
	private let weakStorage = NSHashTable<AnyObject>.weakObjects()
	
	func add(_ object: T) {
		weakStorage.add(object as AnyObject)
	}
	
	func remove(_ object: T) {
		weakStorage.remove(object as AnyObject)
	}
	
	func removeAllObjects() {
		weakStorage.removeAllObjects()
	}
	
	var allObjects: [T] {
		let enumerator = weakStorage.objectEnumerator()
		let iterator = AnyIterator {
			return enumerator.nextObject() as! T?
		}
		return Array(iterator)
	}
}
