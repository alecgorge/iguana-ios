//
//  IGNowPlayingAutoShrinker.m
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGNowPlayingAutoShrinker.h"
#import "AGNowPlayingViewController.h"

@implementation IGNowPlayingAutoShrinker

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
    if([navigationController.view viewWithTag:AGNowPlayingViewController.sharedNowPlayingBar.view.tag] == nil) {
        UIView *v = AGNowPlayingViewController.sharedNowPlayingBar.view;
        [v removeFromSuperview];
        
        CGRect r = v.bounds;
        
        r.origin.y = navigationController.view.bounds.size.height;
        r.size.width = navigationController.view.bounds.size.width;
        
        if (AGNowPlayingViewController.sharedNowPlayingBar.shouldShowBar) {
            r.origin.y = navigationController.view.bounds.size.height - r.size.height;
        }
        
        v.frame = r;
        
        [navigationController.view addSubview:v];
        [navigationController.view bringSubviewToFront:v];
    }
    
    self.lastViewController = viewController;
    
    if(!AGNowPlayingViewController.sharedNowPlayingBar.shouldShowBar) {
        return;
    }
    
    [self fixForViewController:viewController];
}

- (void)fixForViewController:(UIViewController *)viewController {
    if([viewController isKindOfClass:[UITableViewController class]]) {
		UITableView *t = [(UITableViewController*)viewController tableView];
        
		UIEdgeInsets edges = t.contentInset;
		edges.bottom += AGNowPlayingViewController.sharedNowPlayingBar.view.bounds.size.height;
		t.contentInset = edges;
        
		edges = t.scrollIndicatorInsets;
		edges.bottom += AGNowPlayingViewController.sharedNowPlayingBar.view.bounds.size.height;
		t.scrollIndicatorInsets = edges;
	}
	else if ([viewController.view isKindOfClass:[UIScrollView class]]) {
		UIScrollView *t = (UIScrollView*)viewController.view;
        
		UIEdgeInsets edges = t.contentInset;
		edges.bottom += AGNowPlayingViewController.sharedNowPlayingBar.view.bounds.size.height;
		t.contentInset = edges;
        
		edges = t.scrollIndicatorInsets;
		edges.bottom += AGNowPlayingViewController.sharedNowPlayingBar.view.bounds.size.height;
		t.scrollIndicatorInsets = edges;
	}
}

@end
