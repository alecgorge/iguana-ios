//
//  IGPlaylistTracksViewController.h
//  iguana
//
//  Created by Manik Kalra on 11/29/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGRefreshableTableViewController.h"

@interface IGPlaylistTracksViewController : IGRefreshableTableViewController

@property (nonatomic, strong) IGPlaylist *playlist;

-(instancetype)initWithPlaylist:(IGPlaylist *)playlist;

@end
