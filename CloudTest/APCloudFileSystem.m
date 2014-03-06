//
//  APCloudFileSystem.m
//  Created by Alberto Pasca on 05/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APCloudFileSystem.h"
#import "APCloudDocument.h"
#import "APCloudData.h"


NSString *const kDOCUMENT_DIRECTORY    = @"Documents";
NSString *const kDOCUMENT_EXTENSION    = @".dat";

NSString *const APCloudCoreFileSaved   = @"APCloudCoreFileSaved";
NSString *const APCloudCoreFileDeleted = @"APCloudCoreFileDeleted";
NSString *const APCloudCoreFileMoved   = @"APCloudCoreFileMoved";
NSString *const APCloudCoreFileUpdated = @"APCloudCoreFileUpdated";
NSString *const APCloudCoreFileLoaded  = @"APCloudCoreFileLoaded";
NSString *const APCloudCoreFileFail    = @"APCloudCoreFileFail";


@interface APCloudFileSystem ()
{
  
}

- (NSURL*) getCloudFolder;
- (NSURL*) getCloudFileUrl:(NSString*)pFileName prefix:(NSString*)prefix;

@end


@implementation APCloudFileSystem


// +---------------------------------------------------------------------------+
#pragma mark - Initialization
// +---------------------------------------------------------------------------+


+ (instancetype) sharedFileSystem
{
  static APCloudFileSystem *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once ( &onceToken, ^{
    sharedManager = [[self alloc] init];
  });
  
  return sharedManager;
}


// +---------------------------------------------------------------------------+
#pragma mark - Notifications
// +---------------------------------------------------------------------------+


- (void) addObserverForKey:(NSString *) key forObj:(id)obj withOpts:(NSKeyValueObservingOptions)opts
{
  [ self addObserver:obj forKeyPath:key options:opts context:NULL ];
}


// +---------------------------------------------------------------------------+


- (void) removeObserverForKey:(NSString *)key forObj:(id)obj
{
  [ self removeObserver:obj forKeyPath:key ];
}


// +---------------------------------------------------------------------------+
#pragma mark - File paths
// +---------------------------------------------------------------------------+


- (NSURL*) getCloudFolder
{
  NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
  return [ubiq URLByAppendingPathComponent:kDOCUMENT_DIRECTORY];
}


// +---------------------------------------------------------------------------+


- (NSURL*) getCloudFileUrl:(NSString*)pFileName prefix:(NSString*)prefix
{
  return [[self getCloudFolder] URLByAppendingPathComponent:
          [NSString stringWithFormat:@"%@_%@%@", prefix, pFileName, kDOCUMENT_EXTENSION]];
}


// +---------------------------------------------------------------------------+
#pragma mark - File loading
// +---------------------------------------------------------------------------+


- (NSArray*) loadAllFilesWithPrefix:(NSString*)pPrefix
{
  NSFileManager *fm    = [NSFileManager defaultManager];
  NSString *cloudUrl   = [[self getCloudFolder] path];
  NSArray *dirContents = [fm contentsOfDirectoryAtPath:cloudUrl error:nil];
  NSPredicate *fltr    = [NSPredicate predicateWithFormat:@"self BEGINSWITH %@", pPrefix];
  
  return [dirContents filteredArrayUsingPredicate:fltr];
}


// +---------------------------------------------------------------------------+
#pragma mark - File Operations
// +---------------------------------------------------------------------------+


- (void) saveData:(id)cData withName:(NSString*)fName prefix:(NSString*)prefix
{
  APCloudDocument *doc = [[APCloudDocument alloc] initWithFileURL:[self getCloudFileUrl:fName prefix:prefix]];
  doc.storeData        = (NSMutableData*)[[APCloudData sharedData] dataFromClass:cData];

  [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
   {
     if ( success ) {
       if ( _delegate && [_delegate respondsToSelector:@selector(apCloudFileSystemDidFinishSaveData:)] ) {
         [_delegate apCloudFileSystemDidFinishSaveData:cData];
       }
     } else {
       if ( _delegate && [_delegate respondsToSelector:@selector(apCloudFileSystemDidFailSaveData:)] ) {
         [_delegate apCloudFileSystemDidFailSaveData:cData];
       }
     }
   }];
}


// +---------------------------------------------------------------------------+


- (APCloudDocument*) loadDocumentWithName:(NSString*) pName prefix:(NSString*)prefix
{
  return [[APCloudDocument alloc] initWithFileURL:[self getCloudFileUrl:pName prefix:prefix]];
}


// +---------------------------------------------------------------------------+


- (void) deleteFileWithName:(NSString *)fname prefix:(NSString*)prefix
{
  NSURL *fUrl                = [self getCloudFileUrl:fname prefix:prefix];
  NSFileManager* fileManager = [[NSFileManager alloc] init];

  if ( ![fileManager fileExistsAtPath:[fUrl relativePath]] )
  {
    if ( _delegate && [_delegate respondsToSelector:@selector(apCloudFileSystemDidFailDeleteData:)] ) {
      [_delegate apCloudFileSystemDidFailDeleteData:fname];
    }
    return;
  }

  NSError *error;
  NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
  [fileCoordinator coordinateWritingItemAtURL:fUrl options:NSFileCoordinatorWritingForDeleting error:&error byAccessor:^(NSURL* writingURL)
   {
     NSFileManager* fileManager = [[NSFileManager alloc] init];
     [fileManager removeItemAtURL:fUrl error:nil];

     if ( _delegate && [_delegate respondsToSelector:@selector(apCloudFileSystemDidFinishDeleteData:)] ) {
       [_delegate apCloudFileSystemDidFinishDeleteData:fname];
     }
   }];

  if ( error )
    if ( _delegate && [_delegate respondsToSelector:@selector(apCloudFileSystemDidFailDeleteData:)] )
      [_delegate apCloudFileSystemDidFailDeleteData:fname];
}



@end





