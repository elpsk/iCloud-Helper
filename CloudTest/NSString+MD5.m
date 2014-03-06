//
//  NSString+MD5.m
//  Created by Alberto Pasca on 05/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>


/**
 *  Simple encoding MD5 category
 */
@implementation NSString (MD5)

- (NSString *)md5
{
  const char *cStr = [self UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  
  CC_MD5( cStr, (int)strlen(cStr), result );
  
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0],  result[1],  result[2],  result[3],
          result[4],  result[5],  result[6],  result[7],
          result[8],  result[9],  result[10], result[11],
          result[12], result[13], result[14], result[15]
          ];
}

@end
