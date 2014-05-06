//
//  IGNowPlayingAutoShrinker.h
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FRLayeredNavigationController/FRLayeredNavigationController.h>

@interface IGNowPlayingAutoShrinker : NSObject<UINavigationControllerDelegate, FRLayeredNavigationControllerDelegate>

@property (nonatomic) UIViewController *lastViewController;

- (void)addBarToViewController:(UIViewController*)vc;
- (void)fixForViewController:(UIViewController*)vc;

@end
