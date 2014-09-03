//
//  IGLongTextTableViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/28/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGLongTextTableViewController.h"

@interface IGLongTextTableViewController ()

@property (nonatomic, strong) UIFont *font;

@end

@implementation IGLongTextTableViewController

- (instancetype)initWithText:(NSString *)text {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.text = text;
		
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
													   reuseIdentifier:@"cell"];
		self.font = cell.textLabel.font;
		
		[self.tableView registerClass:[UITableViewCell class]
			   forCellReuseIdentifier:@"cell"];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
															forIndexPath:indexPath];
    
    cell.textLabel.text = self.text;
	cell.textLabel.numberOfLines = 0;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = IG_COLOR_CELL_BG;
    cell.textLabel.textColor = IG_COLOR_CELL_TEXT;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat padding = 15;
	CGFloat heightPadding = 20;
	
	CGSize maxSize = CGSizeMake(tableView.frame.size.width - padding * 2, MAXFLOAT);
	
	CGRect labelRect = [self.text boundingRectWithSize:maxSize
											   options:NSStringDrawingUsesLineFragmentOrigin
											attributes:@{NSFontAttributeName:self.font}
											   context:nil];
	
	return labelRect.size.height + heightPadding;
}

@end
