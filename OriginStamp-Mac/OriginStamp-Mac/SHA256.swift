//
//  SHA256.swift
//  OriginStamp-Mac
//
//  Created by Rogerio Hirooka on 8/11/16.
//  Copyright © 2016 Rogerio Hirooka. All rights reserved.
//

import Foundation

class SHA256 {

    static func sha256AsString(data: NSData) -> String? {
        var hash = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA256(data.bytes, CC_LONG(data.length), &hash)
        
        let resstr = NSMutableString()
        for byte in hash {
            resstr.appendFormat("%02hhx", byte)
        }
        
        
        
        return resstr as String
    }

    
}