//
//  IGSourceCell.h
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGNibProxyCell.h"

#import <AXRatingView/AXRatingView.h>

@interface IGSourceCell : IGNibProxyCell

@property (readonly, nonatomic) UILabel *taperLabel;
@property (readonly, nonatomic) UILabel *sourceLabel;
@property (readonly, nonatomic) UILabel *lineageLabel;
@property (readonly, nonatomic) AXRatingView *ratingView;
@property (readonly, nonatomic) UILabel *descriptionLabel;

- (void)updateCellWithShow:(IGShow *)show inTableView:(UITableView*)tableView;
- (CGFloat)heightForCellWithShow:(IGShow *)show inTableView:(UITableView*)tableView;

@end
