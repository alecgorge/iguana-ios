//
//  AGMediaItem.m
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "AGMediaItem.h"

@implementation AGMediaItem

- (NSURL *)shareURLWithTime:(NSTimeInterval)seconds {
    return self.shareURL;
}

- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:AGMediaItem.class]) return NO;
    
    return [self.file isEqual:[object file]];
}

@end
