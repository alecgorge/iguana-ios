//
//  IGNibProxyCell.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGNibProxyCell.h"

@implementation IGNibProxyCell

- (instancetype)initWithCell:(UITableViewCell *)cell {
    if(self = [super init]) {
        self.cell = cell;
        
        [self setup];
    }
    
    return self;
}

- (void)setup {
    NSAssert(0, @"subclass needs to override!");    
}

+ (CGFloat)height {
    NSAssert(0, @"subclass needs to override!");
    return 0;
}

@end
