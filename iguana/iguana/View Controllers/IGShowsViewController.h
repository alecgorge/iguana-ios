//
//  IGYearViewController.h
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGRefreshableTableViewController.h"

@interface IGShowsViewController : IGRefreshableTableViewController

- (instancetype)initWithYear:(IGYear *)year;
- (instancetype)initWithArtist:(IGArtist *)artist andYear:(IGYear *)year;
- (instancetype)initWithVenue:(IGVenue *)venue;
- (instancetype)initWithArtist:(IGArtist *)artist andVenue:(IGVenue *)venue;
- (instancetype)initWithTopShowsOfArtist:(IGArtist *)artist;

@end
