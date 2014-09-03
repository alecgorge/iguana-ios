//
//  NSMutableArray+IGShuffling.m
//  iguana
//
//  Created by Alec Gorge on 3/28/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "NSMutableArray+IGShuffling.h"

@implementation NSMutableArray (IGShuffling)

- (void)ig_shuffle {
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform((u_int32_t)nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
