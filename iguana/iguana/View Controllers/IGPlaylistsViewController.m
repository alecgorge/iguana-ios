//
//  IGPlaylistsViewController.m
//  iguana
//
//  Created by Manik Kalra on 11/29/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGPlaylistsViewController.h"

@interface IGPlaylistsViewController ()

@property (nonatomic) NSArray *playlists;

@end

@implementation IGPlaylistsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playlists = @[];
    self.title = @"Playlists";
}

- (void)refresh:(UIRefreshControl *)sender {
    [[IGAPIClient sharedInstance] playlists:^(NSArray *arr) {
        if(arr) {
            self.playlists = arr;
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
    return self.playlists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *CellIdentifier = @"artist";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"artist"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    IGPlaylist *playlist = self.playlists[indexPath.row];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.text = playlist.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld tracks", (long)playlist.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    IGPlaylistTracksViewController *vc = [[IGPlaylistTracksViewController alloc] initWithPlaylist:self.playlists[row]];
    push_vc(self, vc, NO);
}



@end
