//
//  APCloudFileSystem.h
//  Created by Alberto Pasca on 05/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import <Foundation/Foundation.h>

#if !__has_feature(objc_arc)
#error APCloud use ARC. Please change your settings.
#endif

#if !__has_feature(objc_instancetype)
#undef instancetype
#define instancetype id
#endif


UIKIT_EXTERN NSString *const APCloudCoreFileSaved   NS_AVAILABLE_IOS(5_1);
UIKIT_EXTERN NSString *const APCloudCoreFileDeleted NS_AVAILABLE_IOS(5_1);
UIKIT_EXTERN NSString *const APCloudCoreFileMoved   NS_AVAILABLE_IOS(5_1);
UIKIT_EXTERN NSString *const APCloudCoreFileUpdated NS_AVAILABLE_IOS(5_1);
UIKIT_EXTERN NSString *const APCloudCoreFileLoaded  NS_AVAILABLE_IOS(5_1);
UIKIT_EXTERN NSString *const APCloudCoreFileFail    NS_AVAILABLE_IOS(5_1);

@class APCloudDocument;

/**
 *  APCloudFileSystemDelegate
 */
@protocol APCloudFileSystemDelegate <NSObject>
@optional
/**
 *  Called on finish saving data
 *
 *  @param data Saved data
 */
- (void) apCloudFileSystemDidFinishSaveData:(id)data;
/**
 *  Called on finish deleting data
 *
 *  @param data Deleted data
 */
- (void) apCloudFileSystemDidFinishDeleteData:(id)data;

/**
 *  Called on fail saving data
 *
 *  @param data data to save
 */
- (void) apCloudFileSystemDidFailSaveData:(id)data;
/**
 *  Called on fail delete data
 *
 *  @param data data to delete
 */
- (void) apCloudFileSystemDidFailDeleteData:(id)data;
@end


NS_CLASS_AVAILABLE_IOS(5_1) @interface APCloudFileSystem : NSObject

/**
 *  APCloudFileSystem delegate
 */
@property (nonatomic, weak) id<APCloudFileSystemDelegate> delegate;

/**
 *  Shared instance
 *
 *  @return SELF
 */
+ (instancetype) sharedFileSystem;

/**
 *  Add observer for monitoring changes
 *
 *  @param key  Key
 *  @param obj  Obj
 *  @param opts Option
 */
- (void) addObserverForKey:(NSString *) key forObj:(id)obj withOpts:(NSKeyValueObservingOptions)opts;
/**
 *  Remove observer
 *
 *  @param key Key
 *  @param obj Obj
 */
- (void) removeObserverForKey:(NSString *)key forObj:(id)obj;

/**
 *  Save data to cloud
 *
 *  @param cData  Class to save
 *  @param fName  File name
 *  @param prefix File prefix
 */
- (void) saveData:(id)cData withName:(NSString*)fName prefix:(NSString*)prefix;

/**
 *  Delete a file from cloud
 *
 *  @param fname  File name
 *  @param prefix File prefix
 */
- (void) deleteFileWithName:(NSString *)fname prefix:(NSString*)prefix;

/**
 *  Load all files with prefix
 *
 *  @param pPrefix File prefix
 *
 *  @return File list
 */
- (NSArray*) loadAllFilesWithPrefix:(NSString*)pPrefix;

/**
 *  Load stored UIDocument
 *
 *  @param pName  File name
 *  @param prefix File prefix
 *
 *  @return APCloudDocument
 */
- (APCloudDocument*) loadDocumentWithName:(NSString*) pName prefix:(NSString*)prefix;


@end


