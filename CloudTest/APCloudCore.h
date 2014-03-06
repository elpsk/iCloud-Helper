//
//  APCloudCore.h
//  Created by Alberto Pasca on 04/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APCloudDocument.h"

#if !__has_feature(objc_arc)
#error APCloud require ARC. Please change your settings.
#endif

#if !__has_feature(objc_instancetype)
#undef instancetype
#define instancetype id
#endif

#if TARGET_IPHONE_SIMULATOR
#error "iCloud don't work on iOS Simulator."
#endif


@class  APCloudDocument;

/**
 *  APCloudCoreDelegate
 */
@protocol APCloudCoreDelegate <NSObject>
@optional
/**
 *  Called on forced sync finish
 */
- (void) apCloudCoreDidFinishUpdate;
/**
 *  Called on forced sync fail
 */
- (void) apCloudCoreDidFailUpdate;

/**
 *  Called on load all files finished
 */
- (void) apCloudCoreDidFinishLoadFiles:(NSMutableArray*)file;
/**
 *  Called on load all files faild
 */
- (void) apCloudCoreDidFailLoadFiles;

/**
 *  Called on finished file saving
 */
- (void) apCloudCoreDidFinishSaveData:(id)data;
/**
 *  Called on fail file saving
 */
- (void) apCloudCoreDidFailSaveData:(id)data;

/**
 *  Called on finished file load
 */
- (void) apCloudCoreDidFinishLoadData:(id)data;
/**
 *  Called on fail file load
 */
- (void) apCloudCoreDidFailLoadData:(id)data;

/**
 *  Called on finished file delete
 */
- (void) apCloudCoreDidFinishDeleteData:(id)data;
/**
 *  Called on fail file delete
 */
- (void) apCloudCoreDidFailDeleteData:(id)data;

@end


NS_CLASS_AVAILABLE_IOS(5_1) @interface APCloudCore : NSObject

/**
 *  Array of APCloudData
 */
@property (nonatomic, readonly) NSMutableArray *cloudFiles;

/**
 *  Prefix file name.
 */
@property (nonatomic, strong) NSString *filePrefix;

/**
 *  APCloudCore delegate
 */
@property (nonatomic, weak) id<APCloudCoreDelegate> delegate;

/**
 *  Singleton access
 *
 *  @return self
 */
+ (instancetype) sharedCloud;

/**
 *  Check wheters cloud enabled
 *
 *  @return cloud enabled
 */
- (BOOL) isCloudEnabled;

/**
 *  Force iCloud to syncronize all files in cloud folder.
 */
- (void) forceFilesUpdate;

/**
 *  Save a generic class with name in cloud.
 *  File prefix used is "ap", defaul.
 *  Class MUST respond to NSCoding protocol
 *
 *  @param cData Your class
 *  @param fName File name
 */
- (void) saveData:(id)cData withName:(NSString*)fName;
/**
 *  Save a generic class with name and prefix in cloud.
 *  Class MUST respond to NSCoding protocol
 *
 *  @param cData Your class
 *  @param fName File name
 *  @param prefix File prefix
 */
- (void) saveData:(id)cData withName:(NSString*)fName prefix:(NSString*)prefix;

/**
 *  Load a file with name.
 *  Default file prefix: "ap".
 *
 *  @param fName file name
 */
- (void) loadDataWithName:(NSString*)fName;
/**
 *  Load a file with name and prefix
 *
 *  @param fName  file name
 *  @param prefix file prefix
 */
- (void) loadDataWithName:(NSString*)fName prefix:(NSString*)prefix;

/**
 *  Delete a file with name.
 *  Default prefix: "ap".
 *
 *  @param fname file name
 */
- (void) deleteFileWithName:(NSString *)fname;
/**
 *  Delete a file with name and prefix
 *
 *  @param fname  file name
 *  @param prefix file prefix
 */
- (void) deleteFileWithName:(NSString *)fname prefix:(NSString*)prefix;

/**
 *  Load all files with default prefix ("ap).
 *  @see APCloudCoreDelegate for releated protocols
 */
- (void) loadAllFiles;
/**
 *  Delete a file with name and prefix
 *
 *  @param prefix file prefix
 *  @see APCloudCoreDelegate for releated protocols
 */
- (void) loadAllFilesWithPrefix:(NSString*) prefix;



@end



