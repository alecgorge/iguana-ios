//
//  IGNowPlayingAutoShrinker.m
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGNowPlayingAutoShrinker.h"
#import "AGNowPlayingViewController.h"

#import <FRLayeredNavigationController/FRLayeredNavigationController.h>

@implementation IGNowPlayingAutoShrinker

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
	self.lastViewController = viewController;
    AGNowPlayingViewController.sharedInstance.navigationContainer = navigationController;
	[self fixForViewController:viewController];

	[self addBarToView:navigationController.view];
}

- (void)addBarToView:(UIView *)view {
    if([view viewWithTag:AGNowPlayingViewController.sharedInstance.view.tag] == nil) {
        UIView *v = AGNowPlayingViewController.sharedInstance.view;
        [v removeFromSuperview];
        
        CGRect r = v.bounds;
	
        r.origin.y = view.bounds.size.height;
        r.size.width = view.bounds.size.width;
        
        if (AGNowPlayingViewController.sharedInstance.shouldShowBar) {
            r.origin.y = view.bounds.size.height - r.size.height;
        }
        
        v.frame = r;
        
        [view addSubview:v];
        [view bringSubviewToFront:v];
    }
	
	[view bringSubviewToFront:AGNowPlayingViewController.sharedInstance.view];
    
    if (AGNowPlayingViewController.sharedInstance.shouldShowBar) {
        CGRect r = AGNowPlayingViewController.sharedInstance.view.frame;
        r.origin.y = view.bounds.size.height - r.size.height;
        AGNowPlayingViewController.sharedInstance.view.frame = r;
    }
    else {
        CGRect r = AGNowPlayingViewController.sharedInstance.view.frame;
        r.origin.y = view.bounds.size.height;
        AGNowPlayingViewController.sharedInstance.view.frame = r;
    }
}

- (void)addBarToViewController:(UIViewController *)vc {
	if(IS_IPAD()) {
		[self addBarToView:vc.layeredNavigationController.view];
	}
	else {
		[self addBarToView:vc.navigationController.view];
	}
}

- (void)layeredNavigationController:(FRLayeredNavigationController *)layeredController
			  didPushViewController:(UIViewController *)controller {
	[self fixForViewController:controller];
    AGNowPlayingViewController.sharedInstance.navigationContainer = layeredController;
    self.lastViewController = controller;
	
	for(UIViewController *vc in layeredController.viewControllers) {
		[self fixForViewController:vc];
	}
	
	[self addBarToView:layeredController.view];
}

- (void)fixForViewController:(UIViewController *)viewController {
    if([viewController isKindOfClass:UINavigationController.class]) {
		for(UIViewController *vc2 in ((UINavigationController*)viewController).viewControllers) {
			[self fixForViewController:vc2];
		}
	}
	else if([viewController isKindOfClass:[UITableViewController class]]) {
		UITableView *t = [(UITableViewController*)viewController tableView];
        
		UIEdgeInsets edges = t.contentInset;
		
		if(edges.bottom < AGNowPlayingViewController.sharedInstance.view.bounds.size.height)
			edges.bottom += AGNowPlayingViewController.sharedInstance.view.bounds.size.height;
		
		t.contentInset = edges;
        
		edges = t.scrollIndicatorInsets;

		if(edges.bottom < AGNowPlayingViewController.sharedInstance.view.bounds.size.height)
			edges.bottom += AGNowPlayingViewController.sharedInstance.view.bounds.size.height;
		
		t.scrollIndicatorInsets = edges;
	}
	else if ([viewController.view isKindOfClass:[UIScrollView class]]) {
		UIScrollView *t = (UIScrollView*)viewController.view;
        
		UIEdgeInsets edges = t.contentInset;

		if(edges.bottom < AGNowPlayingViewController.sharedInstance.view.bounds.size.height)
			edges.bottom += AGNowPlayingViewController.sharedInstance.view.bounds.size.height;
		
		t.contentInset = edges;
        
		edges = t.scrollIndicatorInsets;

		if(edges.bottom < AGNowPlayingViewController.sharedInstance.view.bounds.size.height)
			edges.bottom += AGNowPlayingViewController.sharedInstance.view.bounds.size.height;
		
		t.scrollIndicatorInsets = edges;
	}
}

@end
