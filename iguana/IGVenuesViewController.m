//
//  IGVenuesViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/20/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGVenuesViewController.h"

#import <MKFoundationKit/MKFoundationKit.h>

@interface IGVenuesViewController ()

@property (nonatomic) NSArray *venues;
@property (nonatomic) NSArray *indicies;
@property (nonatomic) NSArray *results;

@property (nonatomic) UISearchDisplayController *con;

@end

@implementation IGVenuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Venues";
}

- (void)refresh:(UIRefreshControl *)sender {
    [[IGAPIClient sharedInstance] venues:^(NSArray *arr) {
        if(arr) {
            self.venues = [arr sortedArrayUsingComparator:^NSComparisonResult(IGVenue *obj1, IGVenue *obj2) {
				return [obj1.name caseInsensitiveCompare:obj2.name];
			}];
			[self makeIndicies];
            [self.tableView reloadData];
        }
        
        [super refresh:sender];
    }];
}

- (void)makeIndicies {
    //---create the index---
    NSMutableArray *stateIndex = [[NSMutableArray alloc] init];
    
	for(IGVenue *s in self.venues) {
		char alpha = [s.name.uppercaseString characterAtIndex:0];
        NSString *uniChar = [NSString stringWithFormat:@"%c", alpha];
		if(alpha >= 48 && alpha <= 57) {
			uniChar = @"#";
		}
		
		if(![stateIndex containsObject: uniChar])
			[stateIndex addObject: uniChar];
	}
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44.0f)];
	label.text = [NSString stringWithFormat:@"%lu Venues", (unsigned long)self.venues.count];
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
	label.textColor = [UIColor lightGrayColor];
	
	self.tableView.tableFooterView = label;
	
	self.indicies = stateIndex;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		return 1;
	}
	return self.indicies.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		return nil;
	}
	return self.indicies;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		return nil;
	}
	
	if(section == 0) {
		return @"123";
	}
	return self.indicies[section];
}

- (NSArray *)filterForSection:(NSUInteger) section {
    NSString *alphabet = self.indicies[section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name beginswith[c] %@", alphabet];
	if([alphabet isEqualToString:@"#"]) {
		predicate = [NSPredicate predicateWithFormat:@"SELF.name MATCHES '^[0-9].*'"];
	}
    NSArray *songs = [self.venues filteredArrayUsingPredicate:predicate];
	return songs;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
		return self.results.count;
	}
	return [self filterForSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:@"cell"];
	}
	
	IGVenue *venue;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
		venue = self.results[indexPath.row];
	}
	else {
		venue = [self filterForSection:indexPath.section][indexPath.row];;
	}

	cell.textLabel.text = venue.name;
	cell.detailTextLabel.text = venue.city;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

- (void)createSearchBar {
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
	
	self.con = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
												 contentsController:self];
	
	self.searchDisplayController.searchResultsDelegate = self;
	self.searchDisplayController.searchResultsDataSource = self;
	self.searchDisplayController.delegate = self;
	
	self.tableView.tableHeaderView = searchBar;
}

- (void)updateFilteredContent {
	NSString *src = self.con.searchBar.text;
	self.results = [self.venues mk_select:^BOOL(id object) {
		IGVenue *song = (IGVenue*)object;
		
		BOOL name = [song.name rangeOfString:src
									 options:NSCaseInsensitiveSearch].location != NSNotFound;

		BOOL city = [song.city rangeOfString:src
									 options:NSCaseInsensitiveSearch].location != NSNotFound;
		
		return name || city;
	}];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    [self updateFilteredContent];
	
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(void)dealloc {
	self.con = nil;
}

@end
