//
//  IGAPIClient.m
//  iguana
//
//  Created by Alec Gorge on 3/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGAPIClient.h"

#import <CRToast/CRToast.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "IGIguanaAppConfig.h"

@interface IGAPIClient ()

@property (nonatomic, strong) IGArtist *artist;
@property (nonatomic, strong) IGYear *year;

@end

@implementation IGAPIClient

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        sharedInstance = [[self alloc] initWithBaseURL:IGIguanaAppConfig.apiBase];
    });
    return sharedInstance;
}

- (instancetype)initWithArtist:(IGArtist *)artist
{
    if(self = [super initWithBaseURL:IGIguanaAppConfig.apiBase])
    {
        self.artist = artist;
    }
    
    return self;
}

- (instancetype)initWithArtist:(IGArtist *)artist andYear:(IGYear *)year
{
    if(self = [super initWithBaseURL:IGIguanaAppConfig.apiBase]) {
        self.year = year;
        self.artist = artist;
    }
    
    return self;
}


- (void)failure:(NSError *)error {
    [CRToastManager showNotificationWithOptions:@{
                                                  kCRToastNotificationTypeKey             : @(CRToastTypeNavigationBar),
                                                  kCRToastBackgroundColorKey              : UIColor.redColor,
                                                  kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                                                  kCRToastUnderStatusBarKey               : @(YES),
                                                  kCRToastTextKey                         : error.localizedDescription,
                                                  kCRToastTimeIntervalKey                 : @(5)
                                                  }
                                completionBlock:^{
                                    
                                }];
}

- (void)artists:(void (^)(NSArray *))success {
    [self GET:@"artists"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *r = [responseObject[@"data"] mk_map:^id(id item) {
              NSError *err;
              IGArtist *a = [[IGArtist alloc] initWithDictionary:item
                                                       error:&err];
              
              if(err) {
                  [self failure: err];
                  dbug(@"json err: %@", err);
              }
              
              return a;
          }];
          
          success(r);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self failure:error];
          
          success(nil);
      }];
}

- (NSString *)routeForArtist:(NSString *)route {
    if(self.artist == nil) {
        return [NSString stringWithFormat:@"artists/%@/%@", IGIguanaAppConfig.artistSlug, route];
    }
    
    return [NSString stringWithFormat:@"artists/%@/%@", self.artist.slug, route];
}

- (void)years:(void (^)(NSArray *))success {
    [self GET:[self routeForArtist:@"years"]
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *r = [responseObject[@"data"] mk_map:^id(id item) {
              NSError *err;
              IGYear *y = [[IGYear alloc] initWithDictionary:item
                                                       error:&err];
              
              if(err) {
                  [self failure: err];
                  dbug(@"json err: %@", err);
              }
              
              return y;
          }];
          
          success(r);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self failure:error];
          
          success(nil);
      }];
}

- (void)venues:(void (^)(NSArray *))success {
    [self GET:@"venues"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *r = [responseObject[@"data"] mk_map:^id(id item) {
              NSError *err;
              IGVenue *y = [[IGVenue alloc] initWithDictionary:item
                                                       error:&err];
              
              if(err) {
                  [self failure: err];
                  dbug(@"json err: %@", err);
              }
              
              return y;
          }];
          
          success(r);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self failure:error];
          
          success(nil);
      }];
}

- (void)year:(NSUInteger)year success:(void (^)(IGYear *))success {
    [self GET:[[NSString stringWithFormat:@"artists/%@/years/", self.artist.slug]
               stringByAppendingFormat:@"%lu", (unsigned long)year]
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSError *err;
          IGYear *y = [[IGYear alloc] initWithDictionary:responseObject[@"data"]
                                                   error:&err];
          
          if(err) {
              [self failure: err];
              dbug(@"json err: %@", err);
          }
          
          success(y);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self failure:error];
          
          success(nil);
      }];
}

- (void)venue:(IGVenue *)venue success:(void (^)(IGVenue *))success {
    [self GET:[@"venues/" stringByAppendingFormat:@"%lu", (unsigned long)venue.id]
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSError *err;
          IGVenue *y = [[IGVenue alloc] initWithDictionary:responseObject[@"data"]
													 error:&err];
          
          if(err) {
              [self failure: err];
              dbug(@"json err: %@", err);
          }
          
          success(y);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self failure:error];
          
          success(nil);
      }];
}

- (void)topShows:(void (^)(NSArray *))success {
    [self GET:@"top_shows"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *r = [responseObject[@"data"] mk_map:^id(id item) {
              NSError *err;
              IGShow *y = [[IGShow alloc] initWithDictionary:item
                                                       error:&err];
              
              if(err) {
                  [self failure: err];
                  dbug(@"json err: %@", err);
              }
              else {
                  for(IGTrack *t in y.tracks) {
                      t.show = y;
                  }
              }
              
              return y;
          }];
          
          success(r);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self failure:error];
          
          success(nil);
      }];
}

- (void)showsOn:(NSString *)displayDate success:(void (^)(NSArray *))success {
    [self GET:[@"years/" stringByAppendingFormat:@"%@/shows/%@", [displayDate substringToIndex:4], displayDate]
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *r = [responseObject[@"data"] mk_map:^id(id item) {
              NSError *err;
              IGShow *y = [[IGShow alloc] initWithDictionary:item
                                                       error:&err];
              
              if(err) {
                  [self failure: err];
                  dbug(@"json err: %@", err);
              }
              else {
                  for(IGTrack *t in y.tracks) {
                      t.show = y;
                  }
              }
              
              return y;
          }];
          
          success(r);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self failure:error];
          
          success(nil);
      }];
}

- (void)randomShow:(void (^)(NSArray *))success {
    [self GET:@"random_show"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *r = [responseObject[@"data"] mk_map:^id(id item) {
              NSError *err;
              IGShow *y = [[IGShow alloc] initWithDictionary:item
                                                       error:&err];
              
              if(err) {
                  [self failure: err];
                  dbug(@"json err: %@", err);
              }
              else {
                  for(IGTrack *t in y.tracks) {
                      t.show = y;
                  }
              }
              
              return y;
          }];
          
          success(r);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self failure:error];
          
          success(nil);
      }];
}

@end
