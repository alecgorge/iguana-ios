//
//  IGNibProxyCell.h
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGNibProxyCell : NSObject

+ (CGFloat)height;

- (instancetype)initWithCell:(UITableViewCell*)cell;
- (void)setup;

@property (nonatomic, strong) UITableViewCell *cell;

@end
