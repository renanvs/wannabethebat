//
//  WBBService.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorModel.h"
#import "ComicModel.h"

#define notificationComicListUpdated @"notificationComicListUpdated"

@interface WBBService : NSObject{
    NSManagedObjectContext *context;
    
    NSArray *comicList;
    AuthorModel *authorModel;
}

@property (readonly ,strong) NSManagedObjectContext *context;

@property (assign, nonatomic) AuthorModel *authorModel;

+ (id) sharedInstance;
- (NSArray*)getComicList;

@end
