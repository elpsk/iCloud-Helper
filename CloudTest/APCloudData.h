//
//  APCloudData.h
//  Created by Alberto Pasca on 05/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import <Foundation/Foundation.h>

#if !__has_feature(objc_instancetype)
#undef instancetype
#define instancetype id
#endif


@interface APCloudData : NSObject

/**
 *  Shared instance
 *
 *  @return SELF
 */
+ (instancetype) sharedData;

/**
 *  Convert a class into NSData
 *
 *  @param aClass Your storage class
 *
 *  @return NSData
 */
- (NSData *) dataFromClass:(id)aClass;

/**
 *  Convert a NSData into class
 *
 *  @param aData Your class
 *
 *  @return NSData
 */
- (id) classFromData:(NSData*)cData;

@end
