//
//  APTestStore.h
//  CloudTest
//
//  Created by Alberto Pasca on 03/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APTestStore : NSObject <NSCoding>

@property (nonatomic, strong) NSString *fName;

@property (nonatomic, strong) NSString *aTitle;
@property (nonatomic, strong) NSString *aSubTitle;
@property (nonatomic, strong) NSString *aDescription;

@end
