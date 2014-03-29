//
//  IGIguanaAppConfig.h
//  iguana
//
//  Created by Alec Gorge on 3/1/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGIguanaAppConfig : NSObject

+ (NSString *)bandName;

+ (NSString *)appName;

+ (NSString *)artistSlug;

+ (NSURL *)apiBase;

+ (NSString *)twitterHandle;

+ (NSString *)siteBase;

+ (NSString *)musicBrainzId;

+ (NSString *)itunesAppId;

@end
