//
//  NSString+MD5.h
//  Created by Alberto Pasca on 05/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import <Foundation/Foundation.h>


#if !__has_include(<CommonCrypto/CommonDigest.h>)
#error @"APCloud classes need CommonCrypto framework to work!"
#endif

@interface NSString (MD5)

/**
 *  MD5 NSString category
 *
 *  @return Encoded string
 */
- (NSString *)md5;

@end
