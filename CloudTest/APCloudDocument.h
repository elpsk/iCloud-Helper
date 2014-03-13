//
//  APCloudData.h
//  Created by Alberto Pasca on 03/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Subcass of UIDocument, to store/read data in cloud
 */
NS_CLASS_AVAILABLE_IOS(5_1) @interface APCloudDocument : UIDocument

/**
 *  The data to read/load from cloud
 */
@property (nonatomic, strong) NSMutableData *storeData;

@end

