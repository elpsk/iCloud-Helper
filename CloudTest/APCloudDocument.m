//
//  APCloudData.m
//  Created by Alberto Pasca on 03/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APCloudDocument.h"
#import "NSString+MD5.h"


/*
 *  Encoding key (salt) + MD5. If not using MD5, key in visibile in .dat file!
 */
static const NSString *kSALTKey = @"albert0pasca";

/**
 *  APCloudDocument.
 *  @note This class is used to load and save UIDocuments from or to iCloud.
 *  Every file, before writing to cloud, are "encrypted". Not a strong encryption, 
 *  only a bytestream added to NSData to destroy the content if not removed.
 *
 *  The kSALTKey is encoded in MD5 and appended to NSData, reverse process to read file.
 */
@implementation APCloudDocument


- (BOOL) loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
  kSALTKey = [kSALTKey md5];

  _storeData = [[NSMutableData alloc] initWithBytes:[contents bytes] length:[contents length]];
  [_storeData setLength:[_storeData length] - [kSALTKey length]]; // removing SALT from data
  
  return YES;
}

- (id) contentsForType:(NSString *)typeName error:(NSError **)outError
{
  kSALTKey = [kSALTKey md5];

  NSData *salt = [kSALTKey dataUsingEncoding:NSUTF8StringEncoding];
  [_storeData appendData:salt]; // adding SALT to data
  
  id retData = [NSMutableData dataWithBytes:[_storeData bytes] length:[_storeData length]];
  
#if !__has_feature(objc_arc)
  [_storeData release];
#endif
  
  return retData;
}


@end


