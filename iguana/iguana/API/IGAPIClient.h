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
#import "IGVenue.h"
#import "IGArtist.h"
#import "IGUser.h"
#import "IGPlaylist.h"

@interface IGAPIClient : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (instancetype)initWithArtist:(IGArtist *)artist;
- (instancetype)initWithArtist:(IGArtist *)artist andYear:(IGYear *)year;

// an array of IGYear's
- (void)years:(void (^)(NSArray *))success;

- (void)artists:(void (^)(NSArray *))success;

- (void)playlists:(void (^)(NSArray *))success;

-(void)tracksForPlaylists:(IGPlaylist *)playlist success:(void (^)(NSArray *))success;

- (void)year:(NSUInteger)year success:(void (^)(IGYear *))success;

// an array of IGShow's
- (void)showsOn:(NSString *)displayDate success:(void (^)(NSArray *))success;

- (void)randomShowForArtist:(void (^)(NSArray *))success;

// venues
- (void)venuesForArtist:(void (^)(NSArray *))success;

- (void)venue:(IGVenue *)venue success:(void (^)(IGVenue *))success;

- (void)topShowsForArtist:(void (^)(NSArray *))success;
// authenticated methods
- (void)validateUsername:(NSString *)username
			withPassword:(NSString *)password
				 success:(void(^)(BOOL validCombination))success;

- (void)userProfile:(NSString *)username
			success:(void(^)(IGUser *user))success;

- (void)playlist:(NSString *)slug
		 success:(void (^)(IGPlaylist *playlist))success;

- (void)playlistFromId:(NSUInteger)playlist_id
			   success:(void (^)(IGPlaylist *playlist))success;

@end
