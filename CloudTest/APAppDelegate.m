//
//  APAppDelegate.m
//  CloudTest
//
//  Created by Alberto Pasca on 03/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APAppDelegate.h"

#if TARGET_IPHONE_SIMULATOR
#error "iCloud don't work on iOS Simulator."
#endif

@interface APAppDelegate ()
{
  
}
@end

@implementation APAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  return YES;
}


@end
