//
//  IGShowViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGShowViewController.h"

#import <AXRatingView/AXRatingView.h>
#import <CSNNotificationObserver/CSNNotificationObserver.h>

#import "AGNowPlayingViewController.h"

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
@property (nonatomic, strong) CSNNotificationObserver *trackChangedEvent;
@property (nonatomic, strong) IGArtist *artist;

@end

@implementation IGShowViewController

- (instancetype)initWithShow:(IGShow *)show {
    if(self = [super initWithStyle:UITableViewStylePlain]) {
        self.show = show;
    }
    
    return self;
}

-(instancetype)initWithArtist:(IGArtist *)artist andShow:(IGShow *)show
{
    if(self = [super initWithStyle:UITableViewStylePlain]) {
        self.show = show;
        self.artist = artist;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.show.displayDate;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IGTrackCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"track"];
    
    self.trackChangedEvent = [[CSNNotificationObserver alloc] initWithName:@"AGMediaItemStateChanged"
                                                                    object:nil queue:NSOperationQueue.mainQueue
                                                                usingBlock:^(NSNotification *notification) {
                                                                    [self.tableView reloadData];
                                                                }];
}

- (void)dealloc {
    
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	[self.navigationController.delegate navigationController:self.navigationController
									   didShowViewController:self
													animated:YES];
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
            cell.detailTextLabel.text = self.show.showDescription;
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
            push_vc(self, vc, YES);
		}
		else if(row == IGShowRowDescription) {
			IGLongTextTableViewController *vc = [[IGLongTextTableViewController alloc] initWithText:self.show.showDescription];
			vc.title = @"Description";
            push_vc(self, vc, YES);
		}
		else if(row == IGShowRowSource) {
			IGLongTextTableViewController *vc = [[IGLongTextTableViewController alloc] initWithText:self.show.source];
			vc.title = @"Source";
			
            push_vc(self, vc, YES);
		}
		else if(row == IGShowRowVenue) {
            IGShowsViewController *vc = [[IGShowsViewController alloc] initWithArtist:self.artist andVenue:self.show.venue];
			
            push_vc(self, vc, NO);
		}
		
		return;
	}
	   
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    NSArray *trks = [self.show.tracks mk_map:^id(id item) {
        return [[IGMediaItem alloc] initWithTrack:item
                                             show:self.show];
    }];
    
	// after calling replaceQueueWithItems:startIndex:, shouldShowBar will always be true.
	BOOL shouldShowBar = AGNowPlayingViewController.sharedInstance.shouldShowBar;
	
    [AGMediaPlayerViewController.sharedInstance replaceQueueWithItems:trks
                                                           startIndex:row];
    
	if(!shouldShowBar) {
		[IGAppDelegate.sharedInstance presentMusicPlayer];
		
		// hide the navigation bar while showing the player
		[UIView animateWithDuration:0.3
						 animations:^{
							 self.navigationController.navigationBar.alpha = 0;
						 }
						 completion:^(BOOL finished) {
							 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
								 self.navigationController.navigationBar.alpha = 1;
								 
								 [IGAppDelegate.sharedInstance.autoshrinker addBarToViewController:self];
								 [IGAppDelegate.sharedInstance.autoshrinker fixForViewController:self];
							 });
						 }];
	}
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
