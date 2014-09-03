//
//  AGMediaItem.h
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGMediaItem : NSObject

@property (nonatomic) NSInteger id;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *album;
@property (nonatomic) NSURL *file;

@property (nonatomic) NSString *displayText;
@property (nonatomic) NSString *displaySubText;

@property (nonatomic) NSString *shareText;
@property (nonatomic) NSURL *shareURL;

- (NSURL *)shareURLWithTime:(NSTimeInterval)seconds;

@property (nonatomic, assign) NSTimeInterval duration;

@end
