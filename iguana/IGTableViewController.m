//
//  IGTableViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/28/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface IGTableViewController ()

@property (nonatomic, strong) CAGradientLayer *mask;

@end

@implementation IGTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = IG_COLOR_TABLE_BG;
    self.tableView.separatorColor = IG_COLOR_TABLE_SEP;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.mask.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.tableView.alpha = 1;
                     }];
    
    if(!self.mask) {
        self.mask = [CAGradientLayer layer];
        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
        CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
        
        self.mask.colors = @[(__bridge id)outerColor, (__bridge id)innerColor];
        
        self.mask.locations = @[@0.05, @0.15];
        
        self.mask.bounds = CGRectMake(0, 0,
                                      self.tableView.frame.size.width,
                                      self.tableView.frame.size.height);
        
        self.mask.anchorPoint = CGPointZero;
        
        self.view.layer.mask = self.mask;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.tableView.alpha = 0;
                     }];
}

@end
