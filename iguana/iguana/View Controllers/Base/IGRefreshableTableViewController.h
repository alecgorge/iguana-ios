//
//  IGRefreshableTableViewController.h
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGTableViewController.h"

@interface IGRefreshableTableViewController : IGTableViewController

- (void)refresh:(UIRefreshControl *)sender;

@end
