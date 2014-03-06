//
//  APTableViewController.m
//  CloudTest
//
//  Created by Alberto Pasca on 04/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APTableViewController.h"
#import "APTestStore.h"

@interface APTableCell : UITableViewCell
{
  IBOutlet UILabel *_file;
  IBOutlet UILabel *_title;
  IBOutlet UILabel *_subtitle;
  IBOutlet UILabel *_description;
}

@property (nonatomic, strong) APTestStore *model;
@end

@implementation APTableCell

- (void)setModel:(APTestStore *)model
{
  _model            = model;

  _title.text       = _model.aTitle;
  _subtitle.text    = _model.aSubTitle;
  _description.text = _model.aDescription;
  _file.text        = _model.fName;
}

@end


@interface APTableViewController ()

@end


@implementation APTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _tableview.delegate   = self;
  _tableview.dataSource = self;
}


// +---------------------------------------------------------------------------+
#pragma mark - Action
// +---------------------------------------------------------------------------+


- (IBAction) closeMe:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}


// +---------------------------------------------------------------------------+
#pragma mark - Tableview
// +---------------------------------------------------------------------------+


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  APTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[APTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  cell.model = [_tableArray objectAtIndex:indexPath.row];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.backgroundColor = [UIColor colorWithWhite:indexPath.row % 2 == 0 ? 0.7 : 0.9 alpha:0.1];
}


@end



