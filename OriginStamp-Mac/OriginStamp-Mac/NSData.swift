//
//  NSData.swift
//  OriginStamp-Mac
//
//  Created by Rogerio Hirooka on 8/11/16.
//  Copyright © 2016 Rogerio Hirooka. All rights reserved.
//

import Foundation

extension NSData {
    func hexString() -> NSString {
        let str = NSMutableString()
        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(self.bytes), count:self.length)
        for byte in bytes {
            str.appendFormat("%02hhx", byte)
        }
        return str
    }
}