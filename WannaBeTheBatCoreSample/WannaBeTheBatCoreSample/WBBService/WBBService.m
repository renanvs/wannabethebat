//
//  WBBService.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "WBBService.h"
#include "AFNetworking.h"


@implementation WBBService
@synthesize authorModel;

+(id)sharedInstance{
    static WBBService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)getComicJson{
    NSString *urlStr = @"http://www.wannabethebat.com/feeds/posts/default?alt=json";
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operationManager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id json){
        NSLog(@"json: %@", json);
        [self parseJsonToModels:json];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@", [error localizedDescription]);
    }];
}

-(void)parseJsonToModels:(id)jsonData{
    id feed = jsonData[@"feed"];
    
    if (!feed) {
        return;
    }
    
    authorModel = [self setJsonAuthorToModel:[feed[@"author"] objectAtIndex:0]];
    [authorModel retain];
    
    comicList = [[NSArray alloc] initWithArray:[self setJsonEntryToModelList:feed[@"entry"]]];

}

-(AuthorModel*)setJsonAuthorToModel:(id)jsonAuthor{
    AuthorModel *_authorModel = [[AuthorModel alloc] init];
    
    _authorModel.name = jsonAuthor[@"name"][@"$t"];
    _authorModel.URI = jsonAuthor[@"uri"] [@"$t"];
    _authorModel.imageSrc = jsonAuthor[@"gd$image"] [@"src"];
    _authorModel.mail = jsonAuthor[@"email"] [@"$t"];
    return _authorModel;
}

-(NSArray*)setJsonEntryToModelList:(id)jsonEntry{
    NSArray *entryList = (NSArray*)jsonEntry;
    
    NSMutableArray *comicModelList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *entry in entryList) {
        ComicModel *_comicModel = [[ComicModel alloc] init];
        _comicModel.categoryTerm = [entry[@"category"] lastObject][@"term"];
        _comicModel.contentHTML = entry[@"content"][@"$t"];
        _comicModel.identifier = entry[@"id"][@"$t"];
        _comicModel.thumbURI = entry[@"media$thumbnail"][@"url"];
        _comicModel.publishedDateStr = entry[@"published"][@"$t"];
        _comicModel.updatedDateStr = entry[@"updated"][@"$t"];
        _comicModel.title = entry[@"title"][@"$t"];
        for (id linkData in entry[@"link"]) {
            if ([linkData[@"rel"] isEqualToString:@"alternate"]) {
                _comicModel.link = linkData[@"href"];
            }
        }
        
        [comicModelList addObject:_comicModel];
    }
    
    return comicModelList;
}

-(id)init{
    self = [super init];
    
    if (self) {
        [self getComicJson];
    }
    
    return self;
}

@end
