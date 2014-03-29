//
//  IGEchoNestImages.m
//  iguana
//
//  Created by Alec Gorge on 3/28/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGEchoNestImages.h"

#import <SDWebImage/SDWebImageManager.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "NSMutableArray+IGShuffling.h"

#define EchonestImageCacheFile @"ig_en_cache.plist"
#define MaxImagesToDownloadAtOnce 15

@interface IGEchoNestImages ()

@property (nonatomic, readonly) NSString *cacheFilePath;
@property (nonatomic) NSArray *cache;

@property (atomic) NSInteger imagesRemaining;

@end

@implementation IGEchoNestImages

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://developer.echonest.com/api/v4/"]];
    });
    return sharedInstance;
}

- (NSString *)cacheFilePath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:EchonestImageCacheFile];
}

- (NSArray *)cache {
    return [NSArray arrayWithContentsOfFile:self.cacheFilePath];
}

- (void)setCache:(NSArray *)cache {
    [cache writeToFile:self.cacheFilePath
            atomically:YES];
}

- (void)images:(void (^)(NSArray *))success {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.cacheFilePath]) {
        [self cacheImagesFromURLs:self.cache
                          success:success];
        return;
    }
    
    [self GET:@"artist/images"
   parameters:@{
                @"api_key":@"8RQSIBP0UNAEYNVWV",
                @"results": @100,
                @"id": [NSString stringWithFormat:@"musicbrainz:artist:%@", IGIguanaAppConfig.musicBrainzId]
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *arr = [responseObject[@"response"][@"images"] mk_map:^id(id item) {
              return [NSURL URLWithString:item[@"url"]];
          }];
          self.cache = arr;
          [self cacheImagesFromURLs:arr
                            success:success];
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          
      }];
}

- (void)cacheImagesFromURLs:(NSArray *)arr success:(void (^)(NSArray *))success {
    // select 5 random URLs
    NSMutableArray *sl = [arr mutableCopy];
    [sl ig_shuffle];
    arr = [sl subarrayWithRange:NSMakeRange(0, MIN(MaxImagesToDownloadAtOnce, sl.count))];
    
    NSMutableArray *uiImages = [NSMutableArray array];
    
    self.imagesRemaining = arr.count;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    for (NSURL *u in arr) {
        [manager downloadWithURL:u
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            // progression tracking code
                        }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                           self.imagesRemaining--;
                           if (image) {
                               [uiImages addObject:image];
                               
                               // render after 1 image and after all of them
                               if(self.imagesRemaining == 0 || self.imagesRemaining == MaxImagesToDownloadAtOnce - 1) {
                                   success(uiImages);
                               }
                           }
                       }];
    }
}

@end
