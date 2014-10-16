//
//  IGYearsViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGYearsViewController.h"

#import "IGShowsViewController.h"
#import "IGYearCell.h"

@interface IGYearsViewController ()

@property (nonatomic) NSArray *years;
@property(nonatomic, strong) IGArtist *artist;

@end

@implementation IGYearsViewController

- (instancetype)initWithArtist:(IGArtist *)artist;
{
    if(self = [super init]) {
        self.artist = artist;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.years = @[];
    self.title = @"Years";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IGYearCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"year"];
    
    self.tableView.backgroundColor = IG_COLOR_TABLE_BG;
    self.tableView.separatorColor = IG_COLOR_TABLE_SEP;
}

- (void)refresh:(UIRefreshControl *)sender {
    IGAPIClient *api = [[IGAPIClient alloc] initWithArtist:self.artist];
    [api years:^(NSArray *arr) {
        if(arr) {
            self.years = arr;
            [self.tableView reloadData];
        }
        
        [super refresh:sender];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.years.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"year";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    IGYearCell *c = [[IGYearCell alloc] initWithCell:cell];
    [c updateCellWithYear:self.years[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    IGShowsViewController *vc = [[IGShowsViewController alloc] initWithArtist:self.artist andYear:self.years[row]];
    push_vc(self, vc, NO);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [IGYearCell height];
}

@end
