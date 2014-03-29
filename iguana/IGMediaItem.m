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
        self.artist = [IGIguanaAppConfig bandName];
        self.file = track.mp3;
        
        self.duration = track.length;
        
        self.displayText = track.title;
        self.displaySubText = show.displayDate;
        
        self.shareText = [NSString stringWithFormat:@"#nowplaying %@ — %@ — %@ via %@", self.title, show.displayDate, self.artist, IGIguanaAppConfig.twitterHandle];
        
        // http://lotusod.com/years/2002/shows/2002-08-17/sources/111/tracks/1625/intro-to-a-cell
        self.shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/years/%ld/shows/%@/sources/%ld/tracks/%ld/%@",
                                              IGIguanaAppConfig.siteBase, (long)show.year, show.displayDate,
                                              (long)show.id, (long)track.id, track.slug]];
    }
    
    return self;
}

@end

