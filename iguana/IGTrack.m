//
//  IGTrack.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGTrack.h"

#import "IGShow.h"

@implementation IGTrack

- (NSURL<Ignore> *)mp3 {
    return [NSURL URLWithString:self.file];
}

- (NSString *)shareURLWithPlayedTime:(NSTimeInterval)elapsed {
	NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%ld",
                     IGIguanaAppConfig.siteBase, self.show.displayDate, self.slug, (long)self.id];
	if(elapsed > 0) {
		url = [url stringByAppendingFormat:@"?t=%dm%ds", (int)floor(elapsed / 60), (int)((elapsed - floor(elapsed)) * 60)];
	}
	return [NSURL URLWithString:url];
}

@end
