//
//  WBBDatabaseService.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 01/05/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataService.h"

#define ModelAuthor     @"AuthorModel"
#define ModelComic      @"ComicModel"
#define ModelCategory   @"CategoryModel"

@interface WBBDatabaseService : NSObject{
    NSManagedObjectContext *context;
}

@property(nonatomic, assign) NSManagedObjectContext *context;

+(id)sharedInstance;

-(BOOL)hasContentInDatabase;
-(AuthorModel*)getAuthor;
-(NSArray*)getComicList;
-(BOOL)hasComicContentInDatabase;
-(ComicModel*)getModelById:(NSString*)identifier;
-(void)removeModelFromCoreData:(ComicModel*)comicModel;

@end
