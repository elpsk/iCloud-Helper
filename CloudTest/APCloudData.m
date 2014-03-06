//
//  APCloudData.m
//  Created by Alberto Pasca on 05/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APCloudData.h"


@implementation APCloudData


+ (instancetype) sharedData
{
  static APCloudData *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once ( &onceToken, ^{
    sharedManager = [[self alloc] init];
  });
  
  return sharedManager;
}


// +---------------------------------------------------------------------------+
#pragma mark - NSData archiver
// +---------------------------------------------------------------------------+


- (NSData *) dataFromClass:(id)aClass
{
  return [NSKeyedArchiver archivedDataWithRootObject:aClass];
}


// +---------------------------------------------------------------------------+


- (id) classFromData:(NSData*)cData
{
  return [NSKeyedUnarchiver unarchiveObjectWithData:cData];
}


@end

