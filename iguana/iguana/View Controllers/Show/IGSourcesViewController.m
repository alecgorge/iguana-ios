//
//  IGSourcesViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGSourcesViewController.h"

#import "IGShowViewController.h"
#import "IGSourceCell.h"

NS_ENUM(NSInteger, IGSourcesRows) {
    IGSourcesAverageRatingRow,
    IGSourcesDurationRow,
    IGSourcesTaperRow,
    IGSourcesSourceRow,
    IGSourcesLineageRow,
    IGSourcesSelectRow,
    IGSourcesRowCount,
};

@interface IGSourcesViewController ()

@property (nonatomic, strong) NSString *displayDate;
@property (nonatomic, strong) NSArray *sources;
@property (nonatomic, strong) IGArtist *artist;

@property (nonatomic, strong) UITableViewCell *prototypeCell;

@end

@implementation IGSourcesViewController

- (instancetype)initWithDisplayDate:(NSString *)displayDate {
    if(self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.displayDate = displayDate;
        self.sources = @[];
    }
    
    return self;
}

- (instancetype)initWithArtist:(IGArtist *)artist andDisplayDate:(NSString *)displayDate
{
    if(self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.artist = artist;
        self.displayDate = displayDate;
        self.sources = @[];
    }
    
    return self;
}

- (instancetype)initWithRandomDate {
	if(self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.displayDate = nil;
		self.sources = @[];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	if(self.displayDate)
		self.title = [NSString stringWithFormat:@"%@ Sources", self.displayDate];
	else
		self.title = @"Random Show";
}

- (void)refresh:(UIRefreshControl *)sender {
	if(self.displayDate) {
        IGAPIClient *api = [[IGAPIClient alloc] initWithArtist:self.artist];
		[api showsOn:self.displayDate
									success:^(NSArray *sources) {
										if(sources) {
											self.sources = sources;
											[self.tableView reloadData];
										}
										
										[super refresh:sender];
									}];
	}
	else {
		[IGAPIClient.sharedInstance randomShow:^(NSArray *sources) {
										if(sources) {
											self.displayDate = [sources[0] displayDate];
											self.title = [NSString stringWithFormat:@"%@ Sources", self.displayDate];
											self.sources = sources;
											[self.tableView reloadData];
										}
										
										[super refresh:sender];
									}];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sources.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return IGSourcesRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"source";
    
    if(indexPath.row == IGSourcesAverageRatingRow
    || indexPath.row == IGSourcesDurationRow) {
        CellIdentifier = @"kv";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        if([CellIdentifier isEqualToString:@"source"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            
            if(self.prototypeCell == nil) {
                self.prototypeCell = cell;
            }
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:CellIdentifier];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.imageView.image = nil;
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.numberOfLines = 0;
    
    cell.backgroundColor = IG_COLOR_CELL_BG;
    cell.textLabel.textColor = IG_COLOR_CELL_TEXT;
    cell.detailTextLabel.textColor = IG_COLOR_CELL_TEXT_FADED;
    
    UIView *hilite = [[UIView alloc] initWithFrame:cell.bounds];
    hilite.backgroundColor = IG_COLOR_CELL_TAP_BG;
    cell.selectedBackgroundView = hilite;
    
    NSInteger row = indexPath.row;
    IGShow *show = self.sources[indexPath.section];
    
    if(row == IGSourcesTaperRow) {
        cell.textLabel.text = @"Taper";
        cell.detailTextLabel.text = show.taper;
    }
    else if(row == IGSourcesSourceRow) {
        cell.textLabel.text = @"Source";
        cell.detailTextLabel.text = show.source;
    }
    else if(row == IGSourcesLineageRow) {
        cell.textLabel.text = @"Lineage";
        cell.detailTextLabel.text = show.lineage;
    }
    else if(row == IGSourcesAverageRatingRow) {
        cell.textLabel.text = @"Average Rating";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu  ", (unsigned long)show.reviewsCount];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        AXRatingView *rating = [[AXRatingView alloc] initWithFrame:CGRectMake(0, 0, 51, 20)];
        rating.userInteractionEnabled = NO;
        [rating sizeToFit];
        rating.value = show.averageRating;
        
        cell.accessoryView = rating;
    }
    else if(row == IGSourcesDurationRow) {
        cell.textLabel.text = @"Duration";
        cell.detailTextLabel.text = [IGDurationHelper formattedTimeWithInterval:show.duration];
    }
    else if(row == IGSourcesSelectRow) {
        cell.textLabel.text = @"Listen to this source";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"glyphicons_076_headphones"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = IG_COLOR_TABLE_BUTTON_BG;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    IGShow *show = self.sources[section];
    
    if (row == IGSourcesAverageRatingRow) {
        // push reviews VC
    }
    else if (row == IGSourcesSelectRow) {
        IGShowViewController *vc = [[IGShowViewController alloc] initWithArtist:self.artist andShow:show];
        push_vc(self, vc, NO);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Source %ld of %lu", (long)section + 1, (unsigned long)self.sources.count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;

    IGShow *show = self.sources[indexPath.section];
    
    if(self.prototypeCell == nil) {
        self.prototypeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                    reuseIdentifier:@"source"];
    }
    
    if(row == IGSourcesTaperRow) {
        CGSize constraintSize = CGSizeMake(tableView.bounds.size.width - (2 * 15.0f), INT_MAX);
        CGRect labelSize = [show.taper boundingRectWithSize:constraintSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:self.prototypeCell.detailTextLabel.font}
                                                    context:nil];
        
        return MAX(tableView.rowHeight * 1.2, labelSize.size.height + 30);
    }
    else if(row == IGSourcesSourceRow) {
        CGSize constraintSize = CGSizeMake(tableView.bounds.size.width - (2 * 15.0f), MAXFLOAT);
        CGRect labelSize = [show.source boundingRectWithSize:constraintSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:self.prototypeCell.detailTextLabel.font}
                                                     context:nil];
        
        return MAX(tableView.rowHeight * 1.2, labelSize.size.height + 30);
    }
    else if(row == IGSourcesLineageRow) {
        CGSize constraintSize = CGSizeMake(tableView.bounds.size.width - (2 * 15.0f), MAXFLOAT);
        CGRect labelSize = [show.lineage boundingRectWithSize:constraintSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:self.prototypeCell.detailTextLabel.font}
                                                      context:nil];
        
        return MAX(tableView.rowHeight * 1.2, labelSize.size.height + 30);
    }
    else if(row == IGSourcesAverageRatingRow) {
        return tableView.rowHeight;
    }
    else if(row == IGSourcesDurationRow) {
        return tableView.rowHeight;
    }
    else if(row == IGSourcesSelectRow) {
        return tableView.rowHeight;
    }
    
    return tableView.rowHeight;
}

@end
