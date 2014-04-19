//
//  AGNowPlayingViewController.h
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGNowPlayingViewController : UIViewController<UIGestureRecognizerDelegate>

+ (instancetype)sharedInstance;

@property UINavigationController *navigationContainer;
@property BOOL shouldShowBar;

@end
