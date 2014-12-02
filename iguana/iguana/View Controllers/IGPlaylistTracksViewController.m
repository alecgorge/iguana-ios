//
//  IGPlaylistTracksViewController.m
//  iguana
//
//  Created by Manik Kalra on 11/29/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGPlaylistTracksViewController.h"

@interface IGPlaylistTracksViewController ()

@property (nonatomic, strong) NSArray *tracks;

@end

@implementation IGPlaylistTracksViewController

-(instancetype)initWithPlaylist:(IGPlaylist *)playlist {
    if(self = [super init]) {
        self.playlist = playlist;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)refresh:(UIRefreshControl *)sender {
    [[IGAPIClient sharedInstance] tracksForPlaylists:self.playlist success:^(NSArray *arr) {
        if(arr) {
            self.tracks = arr;
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
    return self.tracks.count;
}



@end
