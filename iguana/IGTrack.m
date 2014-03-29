//
//  IGTrack.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGTrack.h"

@implementation IGTrack

- (NSURL<Ignore> *)mp3 {
    return [NSURL URLWithString:self.file];
}

@end
