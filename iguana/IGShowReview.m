//
//  IGShowReview.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGShowReview.h"

@implementation IGShowReview

+ (JSONKeyMapper*)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
