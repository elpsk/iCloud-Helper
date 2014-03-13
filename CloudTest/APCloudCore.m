//
//  APCloudCore.m
//  Created by Alberto Pasca on 04/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APCloudCore.h"
#import "APCloudFileSystem.h"
#import "APCloudData.h"


static NSString *kDEFAULT_PREFIX = @"ap";

@interface APCloudCore() <APCloudFileSystemDelegate>
{
  NSString        *_filePrefix;
  NSMutableArray  *_cloudFiles;
  NSMetadataQuery *_query;
}
@end


@implementation APCloudCore


// +---------------------------------------------------------------------------+
#pragma mark - Initialization
// +---------------------------------------------------------------------------+


- (id) init
{
  self = [super init];
  if (self)
  {
    _cloudFiles = [[NSMutableArray alloc] init];
    _filePrefix = kDEFAULT_PREFIX;

    [[APCloudFileSystem sharedFileSystem] setDelegate:self];
  }
  return self;
}

- (void) dealloc
{
  #if !__has_feature(objc_arc)
  [super dealloc];
  [_cloudFiles release];
  #endif
}


// +---------------------------------------------------------------------------+


+ (instancetype) sharedCloud
{
  static APCloudCore *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once ( &onceToken, ^{
    sharedManager = [[self alloc] init];
  });
  
  return sharedManager;
}


// +---------------------------------------------------------------------------+


- (void)setDelegate:(id<APCloudCoreDelegate>)delegate
{
  _delegate = delegate;
}

// +---------------------------------------------------------------------------+


- (NSString *) filePrefix
{
  NSAssert( _filePrefix || [_filePrefix length] == 0, @"KO - FILE PREFIX IS MANDATORY!");
  return _filePrefix;
}


// +---------------------------------------------------------------------------+


- (BOOL) isCloudEnabled
{
  NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
  return ubiq != nil;
}


// +---------------------------------------------------------------------------+
#pragma mark - Observer
// +---------------------------------------------------------------------------+


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

}


// +---------------------------------------------------------------------------+
#pragma mark - Load files
// +---------------------------------------------------------------------------+


- (void) loadAllFiles
{
  [self loadAllFilesWithPrefix:_filePrefix];
}


// +---------------------------------------------------------------------------+


- (void) loadAllFilesWithPrefix:(NSString*) prefix
{
  if ( [self isCloudEnabled] )
  {
    _query = [[NSMetadataQuery alloc] init];
    [_query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K BEGINSWITH %@", NSMetadataItemFSNameKey, prefix];
    [_query setPredicate:pred];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryDidFinishGathering:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:_query];
    [_query startQuery];
  }
}


// +---------------------------------------------------------------------------+


- (void) queryDidFinishGathering:(NSNotification *)notification
{
  NSMetadataQuery *query = [notification object];
  [query disableUpdates];
  [query stopQuery];

  [self loadData:query];

  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:NSMetadataQueryDidFinishGatheringNotification
                                                object:query];

#if !__has_feature(objc_arc)
  [_query release];
#endif
  
  _query = nil;
}


// +---------------------------------------------------------------------------+


- (void) loadData:(NSMetadataQuery *)query
{
  [_cloudFiles removeAllObjects];

  if ( [query results].count == 0 )
  {
    [_delegate apCloudCoreDidFailLoadData:nil];
    return;
  }

  [[query results] enumerateObjectsUsingBlock:^(NSMetadataItem *item, NSUInteger idx, BOOL *stop)
   {
     NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
     APCloudDocument *doc = [[APCloudDocument alloc] initWithFileURL:url];
     
     [doc openWithCompletionHandler:^(BOOL success) {
       if (success)
       {
         @try {
           id storedClass = [[APCloudData sharedData] classFromData:doc.storeData];
           [_cloudFiles addObject:storedClass];
           
           if ( _cloudFiles.count == query.resultCount )
             [_delegate apCloudCoreDidFinishLoadFiles:_cloudFiles];
         }
         @catch (NSException *exception) {
           [_delegate apCloudCoreDidFailLoadData:doc];
         }
       }
       else [_delegate apCloudCoreDidFailLoadData:doc];
       
#if !__has_feature(objc_arc)
       [doc release];
#endif
     }];
   }];
}


// +---------------------------------------------------------------------------+
#pragma mark - Sync
// +---------------------------------------------------------------------------+


- (void) forceFilesUpdate
{
  [self enumerateCloudDocuments];
}


// +---------------------------------------------------------------------------+


- (void) enumerateCloudDocuments
{
  if ( [self isCloudEnabled] )
  {
    _query = [[NSMetadataQuery alloc] init];
    [_query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K BEGINSWITH %@", NSMetadataItemFSNameKey, _filePrefix];
    [_query setPredicate:pred];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFiles:) name:NSMetadataQueryDidFinishGatheringNotification object:_query];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFiles:) name:NSMetadataQueryDidUpdateNotification object:_query];

    [_query startQuery];
  }
}


// +---------------------------------------------------------------------------+


- (void) updateFiles:(NSMetadataQuery *)query
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
    [_query disableUpdates];

    NSMutableArray *discoveredFiles = [NSMutableArray array];
    
    NSArray *queryResults = _query.results;

    [queryResults enumerateObjectsUsingBlock:^(NSMetadataItem *result, NSUInteger idx, BOOL *stop)
     {
       NSURL *fileURL = [result valueForAttribute:NSMetadataItemURLKey];
       NSNumber *aBool = nil;
       
       [fileURL getResourceValue:&aBool forKey:NSURLIsHiddenKey error:nil];
       if (aBool && ![aBool boolValue])
         [discoveredFiles addObject:result];
     }];

    NSMutableArray *names = [NSMutableArray array];
    for ( NSMetadataItem *item in _query.results )
    {
      [names addObject:[item valueForAttribute:NSMetadataItemFSNameKey]];
    }

    [_query enableUpdates];
    
#if !__has_feature(objc_arc)
    [_query release];
#endif
  });
}


// +---------------------------------------------------------------------------+


- (void) updateReceived
{
  [_delegate apCloudCoreDidFinishUpdate];
}


// +---------------------------------------------------------------------------+
#pragma mark - Save file
// +---------------------------------------------------------------------------+


- (void) saveData:(id)cData withName:(NSString*)fName
{
  [self saveData:cData withName:fName prefix:_filePrefix];
}


// +---------------------------------------------------------------------------+


- (void) saveData:(id)cData withName:(NSString*)fName prefix:(NSString*)prefix
{
  [[APCloudFileSystem sharedFileSystem] saveData:cData withName:fName prefix:prefix];
}


// +---------------------------------------------------------------------------+
#pragma mark - Load file
// +---------------------------------------------------------------------------+


- (void) loadDataWithName:(NSString*)fName
{
  [self loadDataWithName:fName prefix:_filePrefix];
}


// +---------------------------------------------------------------------------+


- (void) loadDataWithName:(NSString*)fName prefix:(NSString*)prefix
{
  APCloudDocument *doc = [[APCloudFileSystem sharedFileSystem] loadDocumentWithName:fName prefix:prefix];
  [doc openWithCompletionHandler:^(BOOL success)
   {
     if (success)
     {
       id store = [[APCloudData sharedData] classFromData:doc.storeData];
       [_delegate apCloudCoreDidFinishLoadData:store];
     }
     else
       [_delegate apCloudCoreDidFailLoadData:doc];
   }];
}


// +---------------------------------------------------------------------------+
#pragma mark - Delete file
// +---------------------------------------------------------------------------+


- (void) deleteFileWithName:(NSString *)fname
{
  [self deleteFileWithName:fname prefix:_filePrefix];
}


// +---------------------------------------------------------------------------+


- (void) deleteFileWithName:(NSString *)fname prefix:(NSString*)prefix
{
  [[APCloudFileSystem sharedFileSystem] deleteFileWithName:fname prefix:prefix];
}


// +---------------------------------------------------------------------------+
#pragma mark - APCloudFileSystem delegate, OPTIONALS
// +---------------------------------------------------------------------------+


- (void) apCloudFileSystemDidFinishSaveData:(id)data
{
  if ( _delegate && [_delegate respondsToSelector:@selector(apCloudCoreDidFinishSaveData:)])
    [_delegate apCloudCoreDidFinishSaveData:data];
}


// +---------------------------------------------------------------------------+


- (void) apCloudFileSystemDidFinishDeleteData:(id)data
{
  if ( _delegate && [_delegate respondsToSelector:@selector(apCloudCoreDidFinishDeleteData:)])
    [_delegate apCloudCoreDidFinishDeleteData:data];
}


// +---------------------------------------------------------------------------+


- (void) apCloudFileSystemDidFailSaveData:(id)data
{
  if ( _delegate && [_delegate respondsToSelector:@selector(apCloudCoreDidFailSaveData:)])
    [_delegate apCloudCoreDidFailSaveData:data];
}


// +---------------------------------------------------------------------------+


- (void) apCloudFileSystemDidFailDeleteData:(id)data
{
  if ( _delegate && [_delegate respondsToSelector:@selector(apCloudCoreDidFailDeleteData:)])
    [_delegate apCloudCoreDidFailDeleteData:data];
}



@end



