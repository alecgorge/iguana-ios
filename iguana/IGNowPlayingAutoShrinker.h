//
//  IGNowPlayingAutoShrinker.h
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGNowPlayingAutoShrinker : NSObject<UINavigationControllerDelegate>

@property (nonatomic) UIViewController *lastViewController;

- (void)fixForViewController:(UIViewController*)vc;

@end
