//
//  IGArtistsViewController.m
//  iguana
//
//  Created by Manik Kalra on 10/14/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGArtistsViewController.h"
#import "IGYearCell.h"
#import "IGHomeViewController.h"

@interface IGArtistsViewController ()

@property (nonatomic) NSArray *artists;

@end

@implementation IGArtistsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.artists = @[];
    self.title = @"Artists";
    
    [self renderLoginButtons];
}

- (void)refresh:(UIRefreshControl *)sender {
    [[IGAPIClient sharedInstance] artists:^(NSArray *arr) {
        if(arr) {
            self.artists = arr;
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
    return self.artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *CellIdentifier = @"artist";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"artist"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    //IGYearCell *c = [[IGYearCell alloc] initWithCell:cell];
    //[c updateCellWithYear:self.artists[indexPath.row]];
    
    // TODO - conform to standard color schemes
    cell.backgroundColor = [UIColor clearColor];
    IGArtist *artist = self.artists[indexPath.row];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.text = artist.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld recordings", (long)artist.recordingCount];

	UIView *hilite = [[UIView alloc] initWithFrame:cell.bounds];
	hilite.backgroundColor = IG_COLOR_CELL_TAP_BG;
	cell.selectedBackgroundView = hilite;

    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    [[IGAppDelegate sharedInstance] setupSlideshowWithArtist:self.artists[row]];
    
    IGHomeViewController *vc = [[IGHomeViewController alloc] initWithArtist:self.artists[row]];
    push_vc(self, vc, NO);
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [IGYearCell height];
//}

- (void)loginButtonPressed {
    [[IGAuthManager sharedInstance] ensureSignedInFrom:self
                                               success:^{
                                                   [self renderLoginButtons];
                                               }];
}

- (void)signUpButtonPressed {
    [[IGAuthManager sharedInstance] signUpFrom:self
                                       success:^{
                                            [self renderLoginButtons];
                                        }];
}

-(void)logoutButtonPressed {
    [IGAuthManager.sharedInstance signOut];
    [self renderLoginButtons];
}

-(void)playlistButtonPressed {
    IGPlaylistsViewController *playlists = [[IGPlaylistsViewController alloc] init];
    push_vc(self, playlists, NO);
}

-(void)renderLoginButtons {
    // User is signed in
    if(IGAuthManager.sharedInstance.hasCredentials) {
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(logoutButtonPressed)];
        
        self.navigationItem.rightBarButtonItem = logoutButton;
        self.navigationItem.rightBarButtonItem.tintColor = IG_COLOR_ACCENT;
        
        UIBarButtonItem *playlistButton = [[UIBarButtonItem alloc] initWithTitle:@"Playlists"
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(playlistButtonPressed)];
        
        self.navigationItem.leftBarButtonItem = playlistButton;
        self.navigationItem.leftBarButtonItem.tintColor = IG_COLOR_ACCENT;
    }
    // User is not signed in
    else {
    
        UIBarButtonItem *signUpButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(signUpButtonPressed)];
        UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                    style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                   action:@selector(loginButtonPressed)];
        
        self.navigationItem.leftBarButtonItem = signUpButton;
        self.navigationItem.rightBarButtonItem = loginButton;
        self.navigationItem.leftBarButtonItem.tintColor = IG_COLOR_ACCENT;
        self.navigationItem.rightBarButtonItem.tintColor = IG_COLOR_ACCENT;

    }
}

@end
