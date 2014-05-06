//
//  IGAppDelegate.h
//  The Dead On Demand
//
//  Created by Alec Gorge on 3/1/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IGNowPlayingAutoShrinker.h"

void push_vc(UIViewController *obj, UIViewController *vc, BOOL maximumWidth);

@class JBKenBurnsView;

@interface IGAppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype) sharedInstance;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UIView *colorOverlay;
@property (nonatomic) UIView *container;

@property (nonatomic) IGNowPlayingAutoShrinker *autoshrinker;

@property (nonatomic) JBKenBurnsView *kenBurnsView;

@property (nonatomic) UIImageView *randomImageView;
@property (nonatomic) NSArray *randomImages;

@property (nonatomic, readonly) UIImage *currentImage;

- (void)presentMusicPlayer;

@end
