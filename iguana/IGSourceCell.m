//
//  IGSourceCell.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGSourceCell.h"

@implementation IGSourceCell

- (void)setup {
    self.cell.textLabel.hidden = YES;
    self.cell.detailTextLabel.hidden = YES;
}

- (UILabel *)taperLabel {
    return (UILabel *)[self.cell viewWithTag:1];
}

- (UILabel *)sourceLabel {
    return (UILabel *)[self.cell viewWithTag:2];
}

- (UILabel *)lineageLabel {
    return (UILabel *)[self.cell viewWithTag:3];
}

- (AXRatingView *)ratingView {
    return (AXRatingView *)[self.cell viewWithTag:4];
}

- (UILabel *)descriptionLabel {
    return (UILabel *)[self.cell viewWithTag:5];
}

+ (CGFloat)height {
    return 157.0;
}

- (void)updateCellWithShow:(IGShow *)show inTableView:(UITableView *)tableView {
    self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.taperLabel.text = show.taper;
    self.sourceLabel.text = show.source;
    self.lineageLabel.text = show.lineage;
    
    [self.ratingView sizeToFit];
    self.ratingView.value = show.averageRating;
    
    self.descriptionLabel.text = show.description;
    
    self.taperLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.taperLabel.bounds);
    [self.taperLabel setNeedsUpdateConstraints];
    
    self.sourceLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.sourceLabel.bounds);
    [self.sourceLabel setNeedsUpdateConstraints];
    
    self.lineageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.lineageLabel.bounds);
    [self.lineageLabel setNeedsUpdateConstraints];
    
    self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.bounds);
    [self.descriptionLabel setNeedsUpdateConstraints];
    
    [self.cell setNeedsUpdateConstraints];
    [self.cell updateConstraintsIfNeeded];
}

- (CGFloat)heightForCellWithShow:(IGShow *)show
                     inTableView:(UITableView*)tableView {
    [self updateCellWithShow:show inTableView:tableView];
    
    // Make sure the constraints have been set up for this cell, since it may have just been created from scratch.
    // Use the following lines, assuming you are setting up constraints from within the cell's updateConstraints method:
    [self.cell setNeedsUpdateConstraints];
    [self.cell updateConstraintsIfNeeded];
    
    // Set the width of the cell to match the width of the table view. This is important so that we'll get the
    // correct cell height for different table view widths if the cell's height depends on its width (due to
    // multi-line UILabels word wrapping, etc). We don't need to do this above in -[tableView:cellForRowAtIndexPath]
    // because it happens automatically when the cell is used in the table view.
    // Also note, the final width of the cell may not be the width of the table view in some cases, for example when a
    // section index is displayed along the right side of the table view. You must account for the reduced cell width.
    self.cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.cell.bounds));
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints.
    // (Note that you must set the preferredMaxLayoutWidth on multi-line UILabels inside the -[layoutSubviews] method
    // of the UITableViewCell subclass, or do it manually at this point before the below 2 lines!)
    [self.cell setNeedsLayout];
    [self.cell layoutIfNeeded];
    
    // Get the actual height required for the cell's contentView
    CGFloat height = [self.cell.contentView systemLayoutSizeFittingSize:CGSizeMake(tableView.bounds.size.width, 400)].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    height += 1.0f;
    
    NSLog(@"%f", height);

    return height;
}

@end
