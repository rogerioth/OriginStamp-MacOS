//
//  LargeFileHasher.h
//  OriginStamp-Mac
//
//  Created by Rogerio Hirooka on 8/18/16.
//  Copyright © 2016 Rogerio Hirooka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LargeFileHasher : NSObject

+ (NSString *)md5HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)sha1HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)sha256HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)sha512HashOfFileAtPath:(NSString *)filePath;

@end