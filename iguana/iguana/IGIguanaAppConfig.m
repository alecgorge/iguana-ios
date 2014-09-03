//
//  IGIguanaAppConfig.m
//  iguana
//
//  Created by Alec Gorge on 3/1/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGIguanaAppConfig.h"

@implementation IGIguanaAppConfig

+ (NSString *)bandName {
    return NSBundle.mainBundle.infoDictionary[@"iguana"][@"band_name"];
}

+ (NSString *)appName {
    return NSBundle.mainBundle.infoDictionary[@"iguana"][@"app_name"];
}

+ (NSString *)siteBase {
    return NSBundle.mainBundle.infoDictionary[@"iguana"][@"site_base"];
}

+ (NSString *)twitterHandle {
    return NSBundle.mainBundle.infoDictionary[@"iguana"][@"twitter_handle"];
}

+ (NSString *)artistSlug {
    return NSBundle.mainBundle.infoDictionary[@"iguana"][@"iguana_artist_slug"];
}

+ (NSURL *)apiBase {
    return [NSURL URLWithString:NSBundle.mainBundle.infoDictionary[@"iguana"][@"iguana_api_base"]];
}

+ (NSString *)musicBrainzId {
	return NSBundle.mainBundle.infoDictionary[@"iguana"][@"mbid"];
}

+ (NSString *)itunesAppId {
    return NSBundle.mainBundle.infoDictionary[@"iguana"][@"itunes_app_id"];
}

@end
