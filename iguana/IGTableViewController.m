//
//  IGTableViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/28/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGTableViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "AGNowPlayingViewController.h"

@interface IGTableViewController ()

@property (nonatomic, strong) CAGradientLayer *_mask;
@property (nonatomic, assign) BOOL _lastShowBar;

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
    self._mask.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.tableView.alpha = 1;
                     }];
    
    if(!self._mask || AGNowPlayingViewController.sharedInstance.shouldShowBar != self._lastShowBar) {
        self._mask = [CAGradientLayer layer];
        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
        CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
        
        if(AGNowPlayingViewController.sharedInstance.shouldShowBar) {
            self._mask.colors = @[(__bridge id)outerColor, (__bridge id)innerColor,
                                 (__bridge id)innerColor, (__bridge id)outerColor];
        
            self._mask.locations = @[@0.05, @0.15, @0.8, @0.95];
        }
        else {
            self._mask.colors = @[(__bridge id)outerColor, (__bridge id)innerColor];
            
            self._mask.locations = @[@0.05, @0.15];
        }
        
        self._mask.bounds = CGRectMake(0, 0,
                                      self.tableView.frame.size.width,
                                      self.tableView.frame.size.height);
        
        self._mask.anchorPoint = CGPointZero;
        
        self.view.layer.mask = self._mask;
        
        self._lastShowBar = AGNowPlayingViewController.sharedInstance.shouldShowBar;
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
