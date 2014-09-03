//
//  IGShow.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGShow.h"

@implementation IGShow

+ (JSONKeyMapper*)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if([propertyName isEqualToString:@"recordingCount"]) {
        return YES;
    }
    
    return NO;
}

@end
