//
//  IGArtistsViewController.m
//  iguana
//
//  Created by Manik Kalra on 10/14/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGArtistsViewController.h"
#import "IGYearCell.h"

@interface IGArtistsViewController ()

@property (nonatomic) NSArray *artists;

@end

@implementation IGArtistsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.artists = @[];
    self.title = @"Artists";
    
    //[self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"artist"];
    //self.tableView.backgroundColor = IG_COLOR_TABLE_BG;
    //self.tableView.separatorColor = IG_COLOR_TABLE_SEP;
    
    UIBarButtonItem *signupButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(signUpButtonPressed)];
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(loginButtonPressed)];
    self.navigationItem.leftBarButtonItem = signupButton;
    self.navigationItem.rightBarButtonItem = loginButton;
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
    cell.backgroundColor = [UIColor blackColor];
    IGArtist *artist = self.artists[indexPath.row];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.text = artist.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld recordings", (long)artist.recordingCount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    IGYearsViewController *vc = [[IGYearsViewController alloc] initWithArtist:self.artists[row]];
    push_vc(self, vc, NO);
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [IGYearCell height];
//}

- (void)loginButtonPressed
{
    IGSignInViewController *vc = [[IGSignInViewController alloc] init];
    push_vc(self, vc, NO);
}

- (void)signUpButtonPressed
{
    IGSignUpViewController *vc = [[IGSignUpViewController alloc] init];
    push_vc(self, vc, NO);
}

@end
