//
//  IGReviewsTableViewController.h
//  iguana
//
//  Created by Alec Gorge on 3/27/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGTableViewController.h"

@interface IGReviewsTableViewController : IGTableViewController

- (instancetype)initWithShow:(IGShow *)show;

@property (nonatomic, strong) IGShow *show;

@end
