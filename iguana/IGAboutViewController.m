//
//  IGAboutViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/28/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGAboutViewController.h"

#import <ColorUtils/ColorUtils.h>
#import <SVWebViewController/SVWebViewController.h>
#import <VTAcknowledgementsViewController/VTAcknowledgementsViewController.h>

NS_ENUM(NSInteger, IGAboutSections) {
    IGAboutSectionAppInfo,
    IGAboutSectionDeveloperInfo,
    IGAboutSectionAcknowledgements,
    IGAboutSectionCount,
};

NS_ENUM(NSInteger, IGAboutAppInfoRows) {
    IGAboutAppInfoRowTwitter,
    IGAboutAppInfoRowLeaveReview,
    IGAboutAppInfoRowReportBug,
    IGAboutAppInfoRowRequestFeautres,
    IGAboutAppInfoRowCount
};

NS_ENUM(NSInteger, IGAboutDeveloperInfoRows) {
    IGAboutDeveloperInfoRowDeveloper,
    IGAboutDeveloperInfoRowGitHub,
    IGAboutDeveloperInfoRowWebVersion,
//    IGAboutDeveloperInfoRowOtherApps,
    IGAboutDeveloperInfoRowCount
};

NS_ENUM(NSInteger, IGAboutAcknowledgementsRows) {
    IGAboutAcknowledgementsRowAcknowledgements,
    IGAboutAcknowledgementsRowCount
};

@interface IGAboutViewController ()

@end

@implementation IGAboutViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"About";
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return IGAboutSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == IGAboutSectionAppInfo) {
        return IGAboutAppInfoRowCount;
    }
    else if (section == IGAboutSectionDeveloperInfo) {
        return IGAboutDeveloperInfoRowCount;
    }
    else if (section == IGAboutSectionAcknowledgements) {
        return IGAboutAcknowledgementsRowCount;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    
    if (section == IGAboutSectionAppInfo) {
        if (row == IGAboutAppInfoRowTwitter) {
            cell.textLabel.text = [NSString stringWithFormat:@"@%@ on Twitter", IGIguanaAppConfig.twitterHandle];
        }
        else if (row == IGAboutAppInfoRowLeaveReview) {
            cell.textLabel.text = @"Rate .on the App Store";
        }
        else if (row == IGAboutAppInfoRowReportBug) {
            cell.textLabel.text = @"Report a bug";
        }
        else if (row == IGAboutAppInfoRowRequestFeautres) {
            cell.textLabel.text = @"Request a feature";
        }
    }
    else if (section == IGAboutSectionDeveloperInfo) {
        if (row == IGAboutDeveloperInfoRowDeveloper) {
            cell.textLabel.text = @"Built by @alecgorge";
        }
        else if (row == IGAboutDeveloperInfoRowGitHub) {
            cell.textLabel.text = @"Source code on GitHub";
        }
        else if (row == IGAboutDeveloperInfoRowWebVersion) {
            cell.textLabel.text = @"Web version";
        }
//        else if (row == IGAboutDeveloperInfoRowOtherApps) {
//            cell.textLabel.text = @"Other music apps";
//        }
    }
    else if (section == IGAboutSectionAcknowledgements) {
        if (row == IGAboutAcknowledgementsRowAcknowledgements) {
            cell.textLabel.text = @"3rd party acknowledgements";
        }
    }
    
    cell.backgroundColor = IG_COLOR_CELL_BG;
    cell.textLabel.textColor = IG_COLOR_CELL_TEXT_FADED;
    
    UIView *hilite = [[UIView alloc] initWithFrame:cell.bounds];
    hilite.backgroundColor = IG_COLOR_CELL_TAP_BG;
    cell.selectedBackgroundView = hilite;
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section {
    if(section == IGAboutSectionAcknowledgements) {
        return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    
    return nil;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    UIViewController *vc;
    
    if (section == IGAboutSectionAppInfo) {
        if (row == IGAboutAppInfoRowTwitter) {
            NSURL *twitterUrl = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", IGIguanaAppConfig.twitterHandle]];
            NSURL *tweetbotUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/%@", IGIguanaAppConfig.twitterHandle]];
            NSURL *safariUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", IGIguanaAppConfig.twitterHandle]];
            
            NSArray *urls = @[tweetbotUrl, twitterUrl, safariUrl];
            
            for (NSURL *url in urls) {
                if([UIApplication.sharedApplication canOpenURL:url]) {
                    [UIApplication.sharedApplication openURL:url];
                    return;
                }
            }
        }
        else if (row == IGAboutAppInfoRowLeaveReview) {
            NSURL *itunesUrl = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", IGIguanaAppConfig.itunesAppId]];
            [UIApplication.sharedApplication openURL:itunesUrl];
        }
        else if (row == IGAboutAppInfoRowReportBug) {
            vc = [[SVWebViewController alloc] initWithAddress:@"https://github.com/alecgorge/iguana-ios/issues"];
        }
        else if (row == IGAboutAppInfoRowRequestFeautres) {
            vc = [[SVWebViewController alloc] initWithAddress:@"https://github.com/alecgorge/iguana-ios/issues"];
        }
    }
    else if (section == IGAboutSectionDeveloperInfo) {
        if (row == IGAboutDeveloperInfoRowDeveloper) {
            vc = [[SVWebViewController alloc] initWithAddress:@"http://alecgorge.com"];
        }
        else if (row == IGAboutDeveloperInfoRowGitHub) {
            vc = [[SVWebViewController alloc] initWithAddress:@"https://github.com/alecgorge/iguana-ios"];
        }
        else if (row == IGAboutDeveloperInfoRowWebVersion) {
            vc = [[SVWebViewController alloc] initWithAddress:IGIguanaAppConfig.siteBase];
        }
//        else if (row == IGAboutDeveloperInfoRowOtherApps) {
//            
//        }
    }
    else if (section == IGAboutSectionAcknowledgements) {
        if (row == IGAboutAcknowledgementsRowAcknowledgements) {
            vc = [VTAcknowledgementsViewController acknowledgementsViewController];
        }
    }
    
    push_vc(self, vc, YES);
}


@end
