//
//  IGTrackCell.h
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGNibProxyCell.h"

#import <NAKPlaybackIndicatorView/NAKPlaybackIndicatorView.h>

@interface IGTrackCell : IGNibProxyCell

@property (nonatomic, readonly) UILabel *trackNumberLabel;
@property (nonatomic, readonly) NAKPlaybackIndicatorView *playbackIndicatorView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *durationLabel;

- (void)updateCellWithTrack:(IGTrack *)track inTableView:(UITableView*)tableView;
- (CGFloat)heightForCellWithTrack:(IGTrack *)track inTableView:(UITableView*)tableView;

@end
