//
//  IGHomeViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGHomeViewController.h"

#import <JBKenBurnsView/JBKenBurnsView.h>
#import <ColorUtils/ColorUtils.h>

#import "IGAppDelegate.h"
#import "IGEchoNestImages.h"

#import "IGYearsViewController.h"
#import "IGVenuesViewController.h"
#import "IGAboutViewController.h"
#import "IGShowsViewController.h"
#import "IGSourcesViewController.h"
#import "IGArtist.h"

NS_ENUM(NSUInteger, IGHomeRows) {
    IGHomeRowBandName,
    IGHomeRowYears,
    IGHomeRowVenues,
    IGHomeRowTopRatedShows,
    IGHomeRowRandomShow,
    IGHomeRowAbout,
    IGHomeRowCount
};

@interface IGHomeViewController ()

@property(nonatomic, retain) IGArtist *artist;

@end

@implementation IGHomeViewController

-(instancetype)initWithArtist:(IGArtist *)artist {
    if(self = [super initWithStyle:UITableViewStylePlain]) {
        self.artist = artist;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:@"Cell"];
    
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:@"BandName"];
    
    self.tableView.backgroundColor = IG_COLOR_TABLE_BG;
    self.tableView.separatorColor = IG_COLOR_TABLE_SEP;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1.0f;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         IGAppDelegate.sharedInstance.colorOverlay.alpha = IG_SLIDESHOW_HOME_OVERLAY_ALPHA;
                         
                         self.tableView.alpha = 1;
                     }];
}

- (void)viewWillDisappear:(BOOL)animated {
//    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         IGAppDelegate.sharedInstance.colorOverlay.alpha = IG_SLIDESHOW_OVERLAY_ALPHA;

                         self.tableView.alpha = 0;
                     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return IGHomeRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;

    NSString *CellIdentifier = row == IGHomeRowBandName ? @"BandName" : @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = IG_COLOR_CELL_BG;
    cell.textLabel.textColor = IG_COLOR_CELL_TEXT_FADED;

    UIView *hilite = [[UIView alloc] initWithFrame:cell.bounds];
    hilite.backgroundColor = IG_COLOR_CELL_TAP_BG;
    cell.selectedBackgroundView = hilite;
    
    if(row == IGHomeRowYears)
        cell.textLabel.text = @"Years";
    else if(row == IGHomeRowBandName) {
        cell.textLabel.text = self.artist.name;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithDescriptor:cell.textLabel.font.fontDescriptor
                                                    size:24.0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(row == IGHomeRowVenues)
        cell.textLabel.text = @"Venues";
    else if(row == IGHomeRowTopRatedShows)
        cell.textLabel.text = @"Top Rated Shows";
    else if(row == IGHomeRowRandomShow)
        cell.textLabel.text = @"Random Show";
    else if(row == IGHomeRowAbout)
        cell.textLabel.text = @"About";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    UIViewController *vc;
    if(row == IGHomeRowYears) {
        vc = [[IGYearsViewController alloc] initWithArtist:self.artist];
    }
    else if(row == IGHomeRowVenues) {
        vc = [[IGVenuesViewController alloc] initWithArtist:self.artist];
    }
    else if(row == IGHomeRowTopRatedShows) {
        vc = [[IGShowsViewController alloc] initWithTopShowsOfArtist:self.artist];
    }
    else if(row == IGHomeRowRandomShow) {
        vc = [[IGSourcesViewController alloc] initWithRandomDateForArtist:self.artist];
    }
    else if(row == IGHomeRowAbout) {
        vc = [[IGAboutViewController alloc] init];
    }
    
    push_vc(self, vc, NO);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0f;
}

@end
