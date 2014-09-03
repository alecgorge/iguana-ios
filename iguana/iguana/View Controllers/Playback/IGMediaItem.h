//
//  IGMediaItem.h
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "AGMediaItem.h"

@interface IGMediaItem : AGMediaItem

- (instancetype)initWithTrack:(IGTrack *)track show:(IGShow *)show;

@property (nonatomic) IGTrack *track;

@end
