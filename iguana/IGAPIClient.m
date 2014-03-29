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

- (void)years:(void (^)(NSArray *))success {
    [self GET:@"years"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *r = [responseObject[@"data"] mk_map:^id(id item) {
              NSError *err;
              IGYear *y = [[IGYear alloc] initWithDictionary:item
                                                       error:&err];
              
              if(err) {
                  [self failure: err];
                  NSLog(@"json err: %@", err);
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
                  NSLog(@"json err: %@", err);
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
    [self GET:[@"years/" stringByAppendingFormat:@"%lu", (unsigned long)year]
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSError *err;
          IGYear *y = [[IGYear alloc] initWithDictionary:responseObject[@"data"]
                                                   error:&err];
          
          if(err) {
              [self failure: err];
              NSLog(@"json err: %@", err);
          }
          
          success(y);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self failure:error];
          
          success(nil);
      }];
}

- (void)showsOn:(NSString *)displayDate success:(void (^)(NSArray *))success {
    [self GET:[@"years/" stringByAppendingFormat:@"%@/shows/%@", [displayDate substringToIndex:5], displayDate]
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *r = [responseObject[@"data"] mk_map:^id(id item) {
              NSError *err;
              IGShow *y = [[IGShow alloc] initWithDictionary:item
                                                       error:&err];
              
              if(err) {
                  [self failure: err];
                  NSLog(@"json err: %@", err);
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
