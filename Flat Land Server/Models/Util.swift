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
    static func getAngle(_ vector : CGVector)->CGFloat{
        return (atan(vector.dy/vector.dx))
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
