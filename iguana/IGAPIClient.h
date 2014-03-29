//
//  IGAPIClient.h
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <AFHTTPSessionManager.h>

#import "IGYear.h"
#import "IGShow.h"

@interface IGAPIClient : AFHTTPSessionManager

+ (instancetype)sharedInstance;

// an array of IGYear's
- (void)years:(void (^)(NSArray *))success;

- (void)year:(NSUInteger)year success:(void (^)(IGYear *))success;

// an array of IGShow's
- (void)showsOn:(NSString *)displayDate success:(void (^)(NSArray *))success;

// venues
- (void)venues:(void (^)(NSArray *))success;

@end
