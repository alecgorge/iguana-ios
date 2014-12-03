//
//  IGPlaylistTracksViewController.m
//  iguana
//
//  Created by Manik Kalra on 11/29/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGPlaylistTracksViewController.h"

NS_ENUM(NSInteger, IGShowSections) {
    IGPlaylistInfoSection,
    IGPlaylistTracksSection,
    IGPlaylistSectionCount
};

NS_ENUM(NSInteger, IGPlaylistInfoRows) {
    IGPlaylistRowAuthor,
    IGPlaylistRowCreatedOn,
    IGPlaylistRowModifiedOn,
    IGPlaylistRowTrackCount,
    IGPlaylistRowCount
};


@interface IGPlaylistTracksViewController ()

@property (nonatomic, strong) CSNNotificationObserver *trackChangedEvent;

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
    self.title = self.playlist.name;
    [self.tableView registerNib:[UINib nibWithNibName:@"IGTrackCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"track"];
    
    self.trackChangedEvent = [[CSNNotificationObserver alloc] initWithName:@"AGMediaItemStateChanged"
                                                                    object:nil queue:NSOperationQueue.mainQueue
                                                                usingBlock:^(NSNotification *notification) {
                                                                    [self.tableView reloadData];
                                                                }];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.delegate navigationController:self.navigationController
                                       didShowViewController:self
                                                    animated:YES];
}


- (void)refresh:(UIRefreshControl *)sender {
    [[IGAPIClient sharedInstance] tracksForPlaylists:self.playlist success:^(IGPlaylist *arr) {
        if(arr) {
            self.playlist = arr;
            [self.tableView reloadData];
        }
        
        [super refresh:sender];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return IGPlaylistSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(section == IGPlaylistTracksSection)
        return self.playlist.tracks.count;
    else if(section == IGPlaylistInfoSection)
        return IGPlaylistRowCount;
    else
        return 0;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == IGPlaylistTracksSection) {
        return @"Tracks";
    }
    
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if(section == IGPlaylistInfoSection) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
            if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"info"];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(row == IGPlaylistRowAuthor) {
            cell.textLabel.text = @"Author";
            cell.detailTextLabel.text = self.playlist.owner;
        }
        else if(row == IGPlaylistRowCreatedOn) {
            cell.textLabel.text = @"Created On";
            NSString *dateString = [self.formatter stringFromDate:self.playlist.createdAt];
            cell.detailTextLabel.text = dateString;
        }
        else if(row == IGPlaylistRowModifiedOn) {
            cell.textLabel.text = @"Last Modified On";
            NSString *dateString = [self.formatter stringFromDate:self.playlist.updatedAt];
            cell.detailTextLabel.text = dateString;
        }
        else if(row == IGPlaylistRowTrackCount) {
            cell.textLabel.text = @"Tracks";
            cell.detailTextLabel.text = @(self.playlist.tracks.count).stringValue;
        }
        
        cell.backgroundColor = IG_COLOR_CELL_BG;
        cell.textLabel.textColor = IG_COLOR_CELL_TEXT;
        cell.detailTextLabel.textColor = IG_COLOR_CELL_TEXT_FADED;
        return cell;
    }
    else {
        
        static NSString *CellIdentifier = @"track";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
        IGTrackCell *c = [[IGTrackCell alloc] initWithCell:cell];
        [c updateCellWithTrack:self.playlist.tracks[indexPath.row] inTableView:self.tableView];
    
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if(indexPath.section == IGPlaylistTracksSection)
    {
        NSArray *trks = [self.playlist.tracks mk_map:^id(id item) {
            return [[IGMediaItem alloc] initWithTrack:item
                                             show:nil];
        }];
    
        BOOL shouldShowBar = AGNowPlayingViewController.sharedInstance.shouldShowBar;
    
        [AGMediaPlayerViewController.sharedInstance replaceQueueWithItems:trks
                                                           startIndex:indexPath.row];
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

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if(indexPath.section == IGPlaylistInfoSection)
        return tableView.rowHeight;
    else
    {
        IGTrackCell *c = [[IGTrackCell alloc] initWithCell:cell];
    
        return [c heightForCellWithTrack:self.playlist.tracks[indexPath.row]
                         inTableView:tableView];
    }
}




@end
