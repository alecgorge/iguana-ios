//
//  AGMediaPlayerViewController.h
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <DOUAudioStreamer/DOUAudioStreamer.h>

#import "AGMediaItem.h"

@interface AGMediaPlayerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) DOUAudioStreamerStatus state;

// playing, buffering etc
@property (nonatomic, readonly) BOOL playing;

// an array of AGMediaItems
@property (nonatomic) NSMutableArray *playbackQueue;
@property (nonatomic, readonly) AGMediaItem *currentItem;
@property (nonatomic, readonly) AGMediaItem *nextItem;
@property (nonatomic, readonly) IGTrack *currentTrack;
@property (nonatomic, readonly) NSUInteger nextIndex;

@property (nonatomic) NSUInteger currentIndex;

- (void)replaceQueueWithItems:(NSArray *) queue startIndex:(NSUInteger)index;
- (void)addItemsToQueue:(NSArray *)queue;

@property (nonatomic) BOOL shuffle;
@property (nonatomic) BOOL loop;
@property (nonatomic) float progress;

- (void)forward;
- (void)play;
- (void)pause;
- (void)backward;
- (void)togglePlayPause;

@end
