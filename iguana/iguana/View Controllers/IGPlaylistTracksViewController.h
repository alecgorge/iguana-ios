//
//  IGPlaylistTracksViewController.h
//  iguana
//
//  Created by Manik Kalra on 11/29/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGRefreshableTableViewController.h"
#import "IGTrackCell.h"
#import "AGNowPlayingViewController.h"
#import "IGMediaItem.h"
#import <CSNNotificationObserver.h>

@interface IGPlaylistTracksViewController : IGRefreshableTableViewController

@property (nonatomic, strong) IGPlaylist *playlist;
@property (nonatomic, strong) NSDateFormatter *formatter;

-(instancetype)initWithPlaylist:(IGPlaylist *)playlist;

@end
