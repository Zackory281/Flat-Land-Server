//
//  Util.swift
//  Flat Land
//
//  Created by Zackory Cramer on 6/16/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation
import CoreGraphics

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
		print(getAngle(point))
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
