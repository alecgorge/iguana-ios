//
//  IGShowViewController.h
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGRefreshableTableViewController.h"

@interface IGShowViewController : IGRefreshableTableViewController

- (instancetype)initWithShow:(IGShow *)show;
- (instancetype)initWithArtist:(IGArtist *)artist andShow:(IGShow *)show;

@end
