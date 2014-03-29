//
//  IGYearCell.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGYearCell.h"

#import <ColorUtils.h>

@implementation IGYearCell

- (void)setup {
    self.cell.textLabel.hidden = YES;
    self.cell.detailTextLabel.hidden = YES;
}

- (UILabel *)yearLabel {
    return (UILabel *)[self.cell viewWithTag:4];
}

- (UILabel *)durationLabel {
    return (UILabel *)[self.cell viewWithTag:3];
}

- (UILabel *)showAndRecordingLabel {
    return (UILabel *)[self.cell viewWithTag:2];
}

- (AXRatingView *)ratingView {
    return (AXRatingView *)[self.cell viewWithTag:1];
}

- (void)updateCellWithYear:(IGYear *)year {
    self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.yearLabel.text = @(year.year).stringValue;
    self.durationLabel.text = [IGDurationHelper generalizeStringWithInterval:year.duration];
    self.showAndRecordingLabel.text = [NSString stringWithFormat:@"%lu shows, %lu recordings", (unsigned long)year.showCount, (unsigned long)year.recordingCount];
    
    [self.ratingView sizeToFit];
    self.ratingView.value = year.avgRating;
    self.ratingView.userInteractionEnabled = NO;
    
    self.cell.backgroundColor = IG_COLOR_CELL_BG;
    self.yearLabel.textColor = IG_COLOR_CELL_TEXT;
    self.durationLabel.textColor = self.showAndRecordingLabel.textColor = IG_COLOR_CELL_TEXT_FADED;
    
    UIView *hilite = [[UIView alloc] initWithFrame:self.cell.bounds];
    hilite.backgroundColor = IG_COLOR_CELL_TAP_BG;
    self.cell.selectedBackgroundView = hilite;
}

+ (CGFloat)height {
    return 56.0f;
}

@end
