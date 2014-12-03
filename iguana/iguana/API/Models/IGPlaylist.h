//
//  IGPlaylist.h
//  iguana
//
//  Created by Manik Kalra on 11/30/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "JSONModel.h"

@interface IGPlaylist : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger id;


@end
