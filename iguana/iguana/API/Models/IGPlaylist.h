//
//  IGPlaylist.h
//  iguana
//
//  Created by Alec Gorge on 11/2/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "JSONModel.h"

@interface IGPlaylist : JSONModel

@property (nonatomic) NSInteger id;

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *slug;

@property (nonatomic) NSArray<IGTrack> *tracks;

@end
