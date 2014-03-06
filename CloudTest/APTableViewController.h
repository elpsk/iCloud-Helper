//
//  APTableViewController.h
//  CloudTest
//
//  Created by Alberto Pasca on 04/03/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
  IBOutlet UITableView *_tableview;
}

@property (nonatomic, strong) NSMutableArray *tableArray;

- (IBAction) closeMe:(id)sender;

@end
