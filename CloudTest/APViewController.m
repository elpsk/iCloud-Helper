//
//  APViewController.m
//  CloudTest
//
//  Created by Alberto Pasca on 03/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APViewController.h"
#import "APTableViewController.h"

#import "APCloudCore.h"
#import "APTestStore.h"


@interface APViewController () <APCloudCoreDelegate, UITextFieldDelegate>
{
  IBOutlet UITextField *_txtTitle;
  IBOutlet UITextField *_txtSubtitle;
  IBOutlet UITextField *_txtDescription;
  IBOutlet UITextField *_txtPrefix;
  IBOutlet UITextField *_txtFileName;

  NSMutableArray *_cloudFileArray;
}

- (IBAction) check:(id)sender;
- (IBAction) init:(id)sender;
- (IBAction) save:(id)sender;

- (IBAction) deleteFile:(id)sender;
- (IBAction) loadAllFiles:(id)sender;

@end


@implementation APViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [[APCloudCore sharedCloud] setDelegate:self];
  [[APCloudCore sharedCloud] setFilePrefix:@"ap"];
}


// +---------------------------------------------------------------------------+
#pragma mark - Actions
// +---------------------------------------------------------------------------+


- (IBAction) check:(id)sender
{
  if ( [[APCloudCore sharedCloud] isCloudEnabled] )
    alertme(@"iCloud ENABLED on this device.");
  else
    alertme(@"iCloud NOT ENABLED on this device.");
}


// +---------------------------------------------------------------------------+


- (IBAction) init:(id)sender // load
{
  [[APCloudCore sharedCloud] loadDataWithName:_txtFileName.text];
}


// +---------------------------------------------------------------------------+


- (IBAction) save:(UIButton*)button
{
  APTestStore *testStore = [[APTestStore alloc] init];
  testStore.aTitle       = _txtTitle.text;
  testStore.aSubTitle    = _txtSubtitle.text;
  testStore.aDescription = _txtDescription.text;
  testStore.fName        = _txtFileName.text;

  [[APCloudCore sharedCloud] setFilePrefix:_txtPrefix.text];
  [[APCloudCore sharedCloud] saveData:testStore withName:_txtFileName.text];
}

- (IBAction) deleteFile:(id)sender
{
  [[APCloudCore sharedCloud] deleteFileWithName:_txtFileName.text];
}

- (IBAction) loadAllFiles:(id)sender
{
  if ( [_txtPrefix.text length] == 0 ) {
    alertme(@"FAIL - Empty prefix.");
    return;
  }

  [[APCloudCore sharedCloud] loadAllFilesWithPrefix:_txtPrefix.text];
}


// +---------------------------------------------------------------------------+
#pragma mark - APCloudCoreDelegates
// +---------------------------------------------------------------------------+


- (void)apCloudCoreDidFailLoadData:(id)data
{
  alertme(@"Failed to LOAD data.");
}

- (void)apCloudCoreDidFailSaveData:(id)data
{
  alertme(@"Failed to SAVE data.");
}

- (void)apCloudCoreDidFinishLoadData:(id)data
{
  APTestStore *test    = data;

  _txtTitle.text       = test.aTitle;
  _txtSubtitle.text    = test.aSubTitle;
  _txtDescription.text = test.aDescription;
}

- (void)apCloudCoreDidFinishSaveData:(id)data
{
  alertme(@"Saved with success!");
}

- (void)apCloudCoreDidFinishLoadFiles:(NSMutableArray *)file
{
  _cloudFileArray = file;

  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	[ sb instantiateInitialViewController ];
  APTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"APTableViewController"];
  vc.tableArray = _cloudFileArray;
	[self presentViewController:vc animated:YES completion:nil];
}

- (void)apCloudCoreDidFinishDeleteData:(id)data
{
  alertme(@"File deleted successfully!");
}

- (void)apCloudCoreDidFailDeleteData:(id)data
{
  alertme(@"Fail deleting data!");
}

- (void) apCloudCoreDidUpdateReceived
{
  [[APCloudCore sharedCloud] loadDataWithName:_txtFileName.text];
}


// +---------------------------------------------------------------------------+
#pragma mark - UITextField delegate
// +---------------------------------------------------------------------------+


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}


@end



