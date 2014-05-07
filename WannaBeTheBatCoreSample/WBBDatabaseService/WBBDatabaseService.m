//
//  WBBDatabaseService.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 01/05/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "WBBDatabaseService.h"

@implementation WBBDatabaseService
@synthesize context;

SynthensizeSingleTon(WBBDatabaseService)

-(id)init{
    self = [super init];
    if (self) {
        context = [[CoreDataService sharedInstance] context];
    }
    return self;
}

-(NSArray*)getComicList{
    NSEntityDescription *entity = [NSEntityDescription entityForName:ModelComic inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease];
    request.entity = entity;
    NSArray *result = [context executeFetchRequest:request error:nil];
    return result;
}

-(AuthorModel*)getAuthor{
    NSEntityDescription *entity = [NSEntityDescription entityForName:ModelAuthor inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease];
    request.entity = entity;
    NSArray *result = [context executeFetchRequest:request error:nil];
    if (result.count > 0) {
        return [result lastObject];
    }
    return nil;
}

-(BOOL)hasContentInDatabase{
    //AuthorModel *author = [self getAuthor];
    
    if ([self hasComicContentInDatabase]) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)hasComicContentInDatabase{
    NSArray * comicList = [self getComicList];
    if (comicList.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

-(ComicModel*)getModelById:(NSString*)identifier{
    NSEntityDescription *entity = [NSEntityDescription entityForName:ModelComic inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@",identifier];
    request.entity = entity;
    request.predicate = predicate;
    NSArray *result = [context executeFetchRequest:request error:nil];
    if (result.count > 0) {
        ComicModel *comicModel = [result lastObject];
        return comicModel;
    }
    return nil;
}

-(void)removeModelFromCoreData:(ComicModel*)comicModel{
    [context deleteObject:comicModel];
}

@end
