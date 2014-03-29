//
//  IGRefreshableTableViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGRefreshableTableViewController.h"

@interface IGRefreshableTableViewController ()

@end

@implementation IGRefreshableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	UIRefreshControl *c = [[UIRefreshControl alloc] init];
    c.tintColor = IG_COLOR_CELL_TEXT_FADED;
	[c addTarget:self
		  action:@selector(refresh:)
forControlEvents:UIControlEventValueChanged];
	self.refreshControl = c;
	[self beginRefreshingTableView];
    
	[self refresh: self.refreshControl];
}

- (void)refresh:(UIRefreshControl *)sender {
	[sender endRefreshing];
}

- (void)beginRefreshingTableView {
    
    [self.refreshControl beginRefreshing];
    
    if (self.tableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void){
                             self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
    }
}

@end
