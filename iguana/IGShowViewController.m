//
//  IGShowViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGShowViewController.h"

#import <AXRatingView/AXRatingView.h>

#import "IGReviewsTableViewController.h"
#import "IGLongTextTableViewController.h"
#import "IGShowsViewController.h"
#import "IGAppDelegate.h"
#import "IGTrackCell.h"
#import "IGMediaItem.h"

NS_ENUM(NSInteger, IGShowSections) {
    IGShowSectionInfo,
    IGShowSectionTracks,
    IGShowSectionCount,
};

NS_ENUM(NSInteger, IGShowRows) {
    IGShowRowVenue,
    IGShowRowSource,
    IGShowRowDuration,
    IGShowRowReviews,
    IGShowRowDescription,
    IGShowRowCount
};

@interface IGShowViewController ()

@property (nonatomic, strong) IGShow *show;

@end

@implementation IGShowViewController

- (instancetype)initWithShow:(IGShow *)show {
    if(self = [super initWithStyle:UITableViewStylePlain]) {
        self.show = show;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.show.displayDate;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IGTrackCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"track"];
}

- (void)refresh:(UIRefreshControl *)sender {
    [super refresh:sender];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return IGShowSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(section == IGShowSectionInfo) {
        return IGShowRowCount;
    }
    
    return self.show.tracks.count;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == IGShowSectionInfo) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"info"];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if(row == IGShowRowVenue) {
            cell.textLabel.text = @"Venue";
            cell.detailTextLabel.text = self.show.venue.name;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else if(row == IGShowRowSource) {
            cell.textLabel.text = @"Source";
            cell.detailTextLabel.text = self.show.source;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else if(row == IGShowRowDuration) {
            cell.textLabel.text = @"Duration";
            cell.detailTextLabel.text = [IGDurationHelper formattedTimeWithInterval:self.show.duration];
        }
        else if(row == IGShowRowDescription) {
            cell.textLabel.text = @"Description";
            cell.detailTextLabel.text = self.show.description;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else if(row == IGShowRowReviews) {
            cell.textLabel.text = @"Reviews";
            cell.detailTextLabel.text = @(self.show.reviews.count).stringValue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        cell.backgroundColor = IG_COLOR_CELL_BG;
        cell.textLabel.textColor = IG_COLOR_CELL_TEXT;
        cell.detailTextLabel.textColor = IG_COLOR_CELL_TEXT_FADED;
        
        UIView *hilite = [[UIView alloc] initWithFrame:cell.bounds];
        hilite.backgroundColor = IG_COLOR_CELL_TAP_BG;
        cell.selectedBackgroundView = hilite;

        return cell;
    }
    else {
        static NSString *CellIdentifier = @"track";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
        
        IGTrackCell *c = [[IGTrackCell alloc] initWithCell:cell];
        [c updateCellWithTrack:self.show.tracks[row]
                   inTableView:tableView];
        
        return cell;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == IGShowSectionTracks) {
        return @"Tracks";
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section {
    // Background color
    view.tintColor = IG_COLOR_TABLE_HEAD_BG;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = IG_COLOR_CELL_TEXT_FADED;
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

//- (CGFloat)tableView:(UITableView *)tableView
//heightForHeaderInSection:(NSInteger)section {
//    return 44.0f;
//}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    NSUInteger row = indexPath.row;

	if(indexPath.section == IGShowSectionInfo) {
		if(row == IGShowRowReviews) {
			IGReviewsTableViewController *vc = [[IGReviewsTableViewController alloc] initWithShow:self.show];
			[self.navigationController pushViewController:vc
												 animated:YES];
		}
		else if(row == IGShowRowDescription) {
			IGLongTextTableViewController *vc = [[IGLongTextTableViewController alloc] initWithText:self.show.description];
			vc.title = @"Description";
			[self.navigationController pushViewController:vc
												 animated:YES];
		}
		else if(row == IGShowRowSource) {
			IGLongTextTableViewController *vc = [[IGLongTextTableViewController alloc] initWithText:self.show.source];
			vc.title = @"Source";
			
			[self.navigationController pushViewController:vc
												 animated:YES];
		}
		else if(row == IGShowRowVenue) {
			IGShowsViewController *vc = [[IGShowsViewController alloc] initWithVenue:self.show.venue];
			
			[self.navigationController pushViewController:vc
												 animated:YES];
		}
		
		return;
	}
	   
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    NSArray *trks = [self.show.tracks mk_map:^id(id item) {
        return [[IGMediaItem alloc] initWithTrack:item
                                             show:self.show];
    }];
    
    [AGMediaPlayerViewController.sharedInstance replaceQueueWithItems:trks
                                                           startIndex:row];
    
    [IGAppDelegate.sharedInstance presentMusicPlayer];
    
    // hide the navigation bar while showing the player
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.navigationController.navigationBar.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             self.navigationController.navigationBar.alpha = 1;
                         });
                     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == IGShowSectionInfo) {
        return tableView.rowHeight;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"track"];
    
    IGTrackCell *c = [[IGTrackCell alloc] initWithCell:cell];

    return [c heightForCellWithTrack:self.show.tracks[indexPath.row]
                         inTableView:tableView];
}

@end
