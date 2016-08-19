//
//  FileSystem.swift
//  OriginStamp-Mac
//
//  Created by Rogerio Hirooka on 8/11/16.
//  Copyright © 2016 Rogerio Hirooka. All rights reserved.
//

import Foundation

class FileSystem {

    static func fileSizeForPath (path: String) -> UInt64 {
        var fileSize : UInt64 = 0
        
        do {
            let attr : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(path)
            
            if let _attr = attr {
                fileSize = _attr.fileSize();
            }
        } catch {
            print("Error: \(error)")
        }
        
        return fileSize
    }


}