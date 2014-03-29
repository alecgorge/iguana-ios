//
//  IGYearViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGYearViewController.h"

#import "IGSourcesViewController.h"
#import "IGShowCell.h"

@interface IGYearViewController ()

@property (nonatomic, strong) IGYear *year;

@end

@implementation IGYearViewController

- (instancetype)initWithYear:(IGYear *)year {
    if(self = [super init]) {
        self.year = year;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @(self.year.year).stringValue;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IGShowCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"show"];
}

- (void)refresh:(UIRefreshControl *)sender {
    [[IGAPIClient sharedInstance] year:self.year.year success:^(IGYear *year) {
        if(year) {
            self.year = year;
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
    return self.year.shows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    IGShowCell *c = [[IGShowCell alloc] initWithCell:cell];
    [c updateCellWithShow:self.year.shows[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    IGSourcesViewController *vc = [[IGSourcesViewController alloc] initWithDisplayDate:[self.year.shows[row] displayDate]];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [IGShowCell height];
}

@end
