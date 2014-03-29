//
//  IGShowCell.h
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGNibProxyCell.h"

#import <AXRatingView/AXRatingView.h>

@interface IGShowCell : IGNibProxyCell

@property (readonly, nonatomic) UILabel *dateLabel;
@property (readonly, nonatomic) UILabel *sbdLabel;
@property (readonly, nonatomic) AXRatingView *ratingView;
@property (readonly, nonatomic) UILabel *venueLabel;
@property (readonly, nonatomic) UILabel *durationLabel;
@property (readonly, nonatomic) UILabel *recordingCountLabel;

- (void)updateCellWithShow:(IGShow *)show;

@end
