//
//  IGSourcesViewController.h
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGRefreshableTableViewController.h"

@interface IGSourcesViewController : IGRefreshableTableViewController

- (instancetype)initWithDisplayDate:(NSString *)displayDate;
- (instancetype)initWithArtist:(IGArtist *)artist andDisplayDate:(NSString *)displayDate;
- (instancetype)initWithRandomDate;

@end
