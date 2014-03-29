//
//  IGTrackCell.m
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGTrackCell.h"

@implementation IGTrackCell

- (void)setup {
    self.cell.textLabel.hidden = YES;
    self.cell.detailTextLabel.hidden = YES;
}

- (UILabel *)trackNumberLabel {
    return (UILabel *)[self.cell viewWithTag:1];
}

- (NAKPlaybackIndicatorView *)playbackIndicatorView {
    return (NAKPlaybackIndicatorView *)[self.cell viewWithTag:2];
}

- (UILabel *)titleLabel {
    return (UILabel *)[self.cell viewWithTag:3];
}

- (UILabel *)durationLabel {
    return (UILabel *)[self.cell viewWithTag:4];
}

- (void)updateCellWithTrack:(IGTrack *)track inTableView:(UITableView *)tableView {
    self.trackNumberLabel.text = @(track.track).stringValue;
    self.titleLabel.text = track.title;
    self.durationLabel.text = [IGDurationHelper formattedTimeWithInterval:track.length];
    
    if(track.id == AGMediaPlayerViewController.sharedInstance.currentTrack.id) {
        self.trackNumberLabel.hidden = YES;
        if(AGMediaPlayerViewController.sharedInstance.playing) {
            self.playbackIndicatorView.state = NAKPlaybackIndicatorViewStatePlaying;
        }
        else {
            self.playbackIndicatorView.state = NAKPlaybackIndicatorViewStatePaused;
        }
    }
    else {
        self.trackNumberLabel.hidden = NO;
        self.playbackIndicatorView.state = NAKPlaybackIndicatorViewStateStopped;
    }
    
    self.playbackIndicatorView.backgroundColor = IG_COLOR_CELL_BG;
    self.playbackIndicatorView.tintColor = IG_COLOR_CELL_TEXT_FADED;
    
    self.cell.backgroundColor = IG_COLOR_CELL_BG;
    self.titleLabel.textColor = IG_COLOR_CELL_TEXT;
    
    self.trackNumberLabel.textColor =
    self.durationLabel.textColor = IG_COLOR_CELL_TEXT_FADED;
    
    UIView *hilite = [[UIView alloc] initWithFrame:self.cell.bounds];
    hilite.backgroundColor = IG_COLOR_CELL_TAP_BG;
    self.cell.selectedBackgroundView = hilite;
}

- (CGFloat)heightForCellWithTrack:(IGTrack *)track inTableView:(UITableView *)tableView {
    CGFloat leftMargin = 49;
    CGFloat rightMargin = 58;
    
    CGSize constraintSize = CGSizeMake(tableView.bounds.size.width - leftMargin - rightMargin, MAXFLOAT);
    CGRect labelSize = [track.title boundingRectWithSize:constraintSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]}
                                                 context:nil];
    
    return MAX(tableView.rowHeight, labelSize.size.height + 12);
}

@end
