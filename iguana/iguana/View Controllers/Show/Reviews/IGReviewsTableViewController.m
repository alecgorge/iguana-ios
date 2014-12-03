//
//  IGReviewsTableViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/27/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGReviewsTableViewController.h"

#import <AXRatingView/AXRatingView.h>

NS_ENUM(NSInteger, IGShowReviewRows) {
    IGShowReviewRowTitle,
    IGShowReviewRowMetadata,
    IGShowReviewRowBody,
	IGShowReviewRowCount
};

@interface IGReviewsTableViewController ()

@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *font;

@end

@implementation IGReviewsTableViewController

- (instancetype)initWithShow:(IGShow *)show {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.show = show;
		
		self.formatter = [[NSDateFormatter alloc] init];
		self.formatter.dateStyle = NSDateFormatterShortStyle;
		self.formatter.timeStyle = NSDateFormatterNoStyle;
		
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
													   reuseIdentifier:@"asdf"];
		self.font = cell.textLabel.font;
        self.titleFont = [self.font fontWithSize:24.0f];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = [NSString stringWithFormat:@"%lu Reviews", (unsigned long)self.show.reviews.count];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.show.reviews.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return IGShowReviewRowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = indexPath.row;
	NSInteger section = indexPath.section;
	IGShowReview *review = self.show.reviews[section];
	
	UITableViewCell *cell;
	if(row == IGShowReviewRowMetadata) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"metadata"];
		
		if(cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										  reuseIdentifier:@"metadata"];
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.text = review.reviewer;
		cell.detailTextLabel.text = review.reviewdate; // [self.formatter stringFromDate:review.reviewdate];
		
		if(review.stars == nil) {
			cell.accessoryView = nil;
		}
		else {
			AXRatingView *view = [[AXRatingView alloc] init];
			view.value = review.stars.floatValue;
			[view sizeToFit];
			
			cell.accessoryView = view;
		}
	}
	else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"long"];
		
		if(cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
										  reuseIdentifier:@"long"];
		}
        
		cell.textLabel.numberOfLines = 0;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		if(row == IGShowReviewRowTitle) {
			cell.textLabel.text = review.reviewtitle;
            cell.textLabel.font = self.titleFont;
		}
		else if(row == IGShowReviewRowBody) {
			cell.textLabel.text = review.reviewbody;
            cell.textLabel.font = self.font;
		}
	}
    
    cell.backgroundColor = IG_COLOR_CELL_BG;
    cell.textLabel.textColor = IG_COLOR_CELL_TEXT;
    cell.detailTextLabel.textColor = IG_COLOR_CELL_TEXT_FADED;
    
    UIView *hilite = [[UIView alloc] initWithFrame:cell.bounds];
    hilite.backgroundColor = IG_COLOR_CELL_TAP_BG;
    cell.selectedBackgroundView = hilite;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = indexPath.row;
	NSInteger section = indexPath.section;
	IGShowReview *review = self.show.reviews[section];
	
	CGFloat padding = 15;
	CGFloat heightPadding = 20;
	
	if(row == IGShowReviewRowMetadata) {
		return 44.0f * 1.2;
	}
	else if(row == IGShowReviewRowTitle) {
		CGSize maxSize = CGSizeMake(tableView.frame.size.width - padding * 2, MAXFLOAT);
		
		CGRect labelRect = [review.reviewtitle boundingRectWithSize:maxSize
															options:NSStringDrawingUsesLineFragmentOrigin
														 attributes:@{NSFontAttributeName:self.titleFont}
															context:nil];
		return labelRect.size.height + heightPadding;
	}
	else if(row == IGShowReviewRowBody) {
		CGSize maxSize = CGSizeMake(tableView.frame.size.width - padding * 2, MAXFLOAT);
		
		CGRect labelRect = [review.reviewbody boundingRectWithSize:maxSize
														   options:NSStringDrawingUsesLineFragmentOrigin
														attributes:@{NSFontAttributeName:self.font}
														   context:nil];
		return labelRect.size.height + heightPadding;
	}
	
	return 44.0f;
}

@end
