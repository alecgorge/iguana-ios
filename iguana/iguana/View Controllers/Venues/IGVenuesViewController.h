//
//  IGVenuesViewController.h
//  iguana
//
//  Created by Alec Gorge on 3/20/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGRefreshableTableViewController.h"
#import "IGArtist.h"

@interface IGVenuesViewController : IGRefreshableTableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

-(instancetype)initWithArtist:(IGArtist *)artist;

@end
