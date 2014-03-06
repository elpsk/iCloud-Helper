//
//  APTestStore.m
//  CloudTest
//
//  Created by Alberto Pasca on 03/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APTestStore.h"

@implementation APTestStore

- (id) initWithCoder:(NSCoder *)decoder
{
  if ( self = [super init] )
  {
    self.fName        = [decoder decodeObjectForKey:@"fname"];

    self.aTitle       = [decoder decodeObjectForKey:@"title"];
    self.aSubTitle    = [decoder decodeObjectForKey:@"subtitle"];
    self.aDescription = [decoder decodeObjectForKey:@"description"];
  }
  return self;
}

- (void) encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:self.fName        forKey:@"fname"];

  [coder encodeObject:self.aTitle       forKey:@"title"];
  [coder encodeObject:self.aSubTitle    forKey:@"subtitle"];
  [coder encodeObject:self.aDescription forKey:@"description"];
}

@end
