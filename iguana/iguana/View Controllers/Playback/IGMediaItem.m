//
//  IGMediaItem.m
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGMediaItem.h"

@implementation IGMediaItem

- (instancetype)initWithTrack:(IGTrack *)track show:(IGShow *)show{
    if (self = [super init]) {
        self.track = track;
        
        self.title = track.title;
        self.album = [NSString stringWithFormat:@"%@ — %@ — %@", show.displayDate, show.venue.name, show.venue.city];
        self.artist = IGIguanaAppConfig.bandName;
        self.file = track.mp3;
        
        self.duration = track.length;
        
        self.displayText = track.title;
        self.displaySubText = show.displayDate;        
    }
    
    return self;
}

- (NSURL *)shareURL {
    return [self.track shareURLWithPlayedTime:0];
}

- (NSURL *)shareURLWithTime:(NSTimeInterval)seconds {
    return [self.track shareURLWithPlayedTime:seconds];
}

- (NSString *)shareText {
    return [NSString stringWithFormat:@"#nowplaying %@ — %@ — %@ via @%@", self.title, self.track.show.displayDate, self.artist, IGIguanaAppConfig.twitterHandle];
}

@end

