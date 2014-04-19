//
//  IGThirdPartyKeys.h
//  iguana
//
//  Created by Alec Gorge on 3/29/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGThirdPartyKeys : NSObject

+ (instancetype)sharedInstance;

@property (readonly) BOOL isFlurryEnabled;
@property (readonly) NSString *flurryApiKey;

@property (readonly) BOOL isLastFmEnabled;
@property (readonly) NSString *lastFmApiKey;
@property (readonly) NSString *lastFmApiSecret;

@property (readonly) BOOL isCrashlyticsEnabled;
@property (readonly) NSString *crashlyticsApiKey;

@end
