//
//  IGYearCell.h
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGNibProxyCell.h"

#import <AXRatingView/AXRatingView.h>

@interface IGYearCell : IGNibProxyCell

@property (readonly, nonatomic) UILabel *yearLabel;
@property (readonly, nonatomic) UILabel *durationLabel;
@property (readonly, nonatomic) UILabel *showAndRecordingLabel;
@property (readonly, nonatomic) AXRatingView *ratingView;

- (void)updateCellWithYear:(IGYear *)year;

@end
