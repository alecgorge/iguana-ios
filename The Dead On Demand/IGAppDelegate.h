//
//  IGAppDelegate.h
//  The Dead On Demand
//
//  Created by Alec Gorge on 3/1/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBKenBurnsView;

@interface IGAppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype) sharedInstance;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UIView *colorOverlay;
@property (nonatomic) JBKenBurnsView *kenBurnsView;

- (void)presentMusicPlayer;

@end
