//
//  IGYearsViewController.h
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGRefreshableTableViewController.h"
#import "IGArtist.h"

@interface IGYearsViewController : IGRefreshableTableViewController

- (instancetype)initWithArtist:(IGArtist *)artist;

@end
