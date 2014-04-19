//
//  IGThirdPartyKeys.m
//  iguana
//
//  Created by Alec Gorge on 3/29/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGThirdPartyKeys.h"

@interface IGThirdPartyKeys ()

@property (nonatomic, strong) NSDictionary *config;

@end

@implementation IGThirdPartyKeys

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.config = [NSDictionary.alloc initWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"API Keys"
                                                                                               ofType:@"plist"]];
    }
    return self;
}

- (BOOL)isFlurryEnabled {
    return [self.config[@"flurry_enabled"] boolValue] && self.config[@"flurry_keys"][IGIguanaAppConfig.artistSlug];
}

- (NSString *)flurryApiKey {
    return self.config[@"flurry_keys"][IGIguanaAppConfig.artistSlug];
}

- (BOOL)isLastFmEnabled {
    return [self.config[@"lastfm_enabled"] boolValue];
}

- (NSString *)lastFmApiKey {
    return self.config[@"lastfm_key"];
}

- (NSString *)lastFmApiSecret {
    return self.config[@"lastfm_secret"];
}

- (BOOL)isCrashlyticsEnabled {
    return [self.config[@"crashlytics_enabled"] boolValue];
}

- (NSString *)crashlyticsApiKey {
    return self.config[@"crashlytics_key"];
}

@end
