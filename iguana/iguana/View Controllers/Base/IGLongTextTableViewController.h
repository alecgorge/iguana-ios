//
//  IGLongTextTableViewController.h
//  iguana
//
//  Created by Alec Gorge on 3/28/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGTableViewController.h"

@interface IGLongTextTableViewController : IGTableViewController

- (instancetype)initWithText:(NSString *)text;

@property (nonatomic, strong) NSString *text;

@end
