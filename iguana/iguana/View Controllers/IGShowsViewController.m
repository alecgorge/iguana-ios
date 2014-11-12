//
//  IGYearViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGShowsViewController.h"

#import "IGSourcesViewController.h"
#import "IGShowCell.h"

@interface IGShowsViewController ()

@property (nonatomic, strong) IGYear *year;
@property (nonatomic, strong) IGArtist *artist;
@property (nonatomic, strong) IGVenue *venue;
@property (nonatomic, strong) NSArray *shows;

@end

@implementation IGShowsViewController

- (instancetype)initWithYear:(IGYear *)year {
    if(self = [super init]) {
        self.year = year;
    }
    
    return self;
}

- (instancetype)initWithArtist:(IGArtist *)artist andYear:(IGYear *)year
{
    if(self = [super init]) {
        self.year = year;
        self.artist = artist;
    }
    
    return self;
}

- (instancetype)initWithVenue:(IGVenue *)venue {
    if(self = [super init]) {
        self.venue = venue;
    }
    
    return self;
}

-(instancetype)initWithArtist:(IGArtist *)artist andVenue:(IGVenue *)venue
{
    if(self = [super init]) {
        self.venue = venue;
        self.artist = artist;
    }
    
    return self;
}

-(instancetype)initWithTopShowsOfArtist:(IGArtist *)artist {
	if(self = [super init]) {
		self.shows = @[];
        self.artist = artist;
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.year)
        self.title = @(self.year.year).stringValue;
	else if(self.venue)
		self.title = self.venue.name;
	else
		self.title = @"Top Shows";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IGShowCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"show"];
}

- (void)refresh:(UIRefreshControl *)sender {
    if(self.year) {
        IGAPIClient *api = [[IGAPIClient alloc] initWithArtist:self.artist andYear:self.year];
        [api year:self.year.year success:^(IGYear *year) {
            if(year) {
                self.year = year;
                [self.tableView reloadData];
            }
            
            [super refresh:sender];
        }];
    }
	else if (self.venue) {
        IGAPIClient *api = [[IGAPIClient alloc] initWithArtist:self.artist andYear:self.year];
        [api venue:self.venue success:^(IGVenue *venue) {
            if(venue) {
                self.venue = venue;
                [self.tableView reloadData];
            }
            
            [super refresh:sender];
        }];
		
	}
    else {
        IGAPIClient *api = [[IGAPIClient alloc] initWithArtist:self.artist];
        [api topShowsForArtist:^(NSArray *shows) {
            if(shows) {
                self.shows = shows;
                [self.tableView reloadData];
            }
            
            [super refresh:sender];
        }];
    }
}

- (NSArray *)subShows {
	if(self.year) {
		return self.year.shows;
	}
	else if(self.venue) {
		return self.venue.shows;
	}
	
	return self.shows;
}

- (IGShow *)showForIndexPath:(NSIndexPath *)indexPath {
	return [self subShows][indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self subShows].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
	IGShow *show = [self showForIndexPath:indexPath];
	
    IGShowCell *c = [[IGShowCell alloc] initWithCell:cell];
    [c updateCellWithShow:show];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
	IGShow *show = [self showForIndexPath:indexPath];
    IGSourcesViewController *vc = [[IGSourcesViewController alloc] initWithArtist:self.artist
                                                                   andDisplayDate:show.displayDate];
    push_vc(self, vc, NO);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [IGShowCell height];
}

@end
