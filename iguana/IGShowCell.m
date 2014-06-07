//
//  IGShowCell.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGShowCell.h"

@implementation IGShowCell

- (void)setup {
    self.cell.textLabel.hidden = YES;
    self.cell.detailTextLabel.hidden = YES;
}

- (UILabel *)dateLabel {
    return (UILabel *)[self.cell viewWithTag:1];
}

- (UILabel *)sbdLabel {
    return (UILabel *)[self.cell viewWithTag:2];
}

- (AXRatingView *)ratingView {
    return (AXRatingView *)[self.cell viewWithTag:3];
}

- (UILabel *)venueLabel {
    return (UILabel *)[self.cell viewWithTag:4];
}

- (UILabel *)durationLabel {
    return (UILabel *)[self.cell viewWithTag:5];
}

- (UILabel *)recordingCountLabel {
    return (UILabel *)[self.cell viewWithTag:6];
}

- (void)updateCellWithShow:(IGShow *)show {
    self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.dateLabel.text = show.displayDate;
    self.sbdLabel.hidden = !show.isSoundboard;
    
    [self.ratingView sizeToFit];
    self.ratingView.value = show.averageRating;
    self.ratingView.userInteractionEnabled = NO;

    self.venueLabel.text = [NSString stringWithFormat:@"%@\n%@", show.venueName, show.venueCity];
    self.durationLabel.text = [IGDurationHelper formattedTimeWithInterval:show.duration];
    self.recordingCountLabel.text = [NSString stringWithFormat:@"%@ recordings", show.recordingCount ? show.recordingCount : @(0)];
    
    self.cell.backgroundColor = IG_COLOR_CELL_BG;
    self.dateLabel.textColor = IG_COLOR_CELL_TEXT;
    
    self.durationLabel.textColor =
    self.recordingCountLabel.textColor =
    self.venueLabel.textColor = IG_COLOR_CELL_TEXT_FADED;
    
    UIView *hilite = [[UIView alloc] initWithFrame:self.cell.bounds];
    hilite.backgroundColor = IG_COLOR_CELL_TAP_BG;
    self.cell.selectedBackgroundView = hilite;
}

+ (CGFloat)height {
    return 70.0f;
}

@end
