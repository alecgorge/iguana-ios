//
//  IGEchoNestImages.h
//  iguana
//
//  Created by Alec Gorge on 3/28/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface IGEchoNestImages : AFHTTPSessionManager

+ (instancetype)sharedInstance;

// an array of NSStrings as paths to the files
- (void)imagesForArtist:(IGArtist *)artist success:(void (^)(NSArray *))success;

@end
