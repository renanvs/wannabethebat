//
//  WBBService.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "WBBService.h"
#include "AFNetworking.h"
#import "Utils.h"
#import "HTMLParser.h"
#import "HTMLNode.h"

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
    //NSString *urlStr = @"http://www.wannabethebat.com/feeds/posts/default?alt=json";
    NSString *urlStr = @"http://localhost/~renansilva/temp/default.json";
    
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationComicListUpdated object:nil];

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
        
        NSString *category = [entry[@"category"] lastObject][@"term"];
        _comicModel.categoryTerm = [[NSString alloc] initWithStringNeverNil:category];

        NSString *contentHMTL = entry[@"content"][@"$t"];
        _comicModel.contentHTML = [[NSString alloc] initWithStringNeverNil:contentHMTL];
        
        NSString *identifier = entry[@"id"][@"$t"];
        _comicModel.identifier = [[NSString alloc] initWithStringNeverNil:identifier];
        
        NSString *thumbUrl = entry[@"media$thumbnail"][@"url"];
        _comicModel.thumbURI = [[NSString alloc] initWithStringNeverNil:thumbUrl];
        
        NSString *publishedDate = entry[@"published"][@"$t"];
        _comicModel.publishedDateStr = [[NSString alloc] initWithStringNeverNil:publishedDate];
        
        NSString *updatedDate = entry[@"updated"][@"$t"];
        _comicModel.updatedDateStr = [[NSString alloc] initWithStringNeverNil:updatedDate];
        
        NSString *title = entry[@"title"][@"$t"];
        _comicModel.title = [[NSString alloc] initWithStringNeverNil:title];
        
        _comicModel.imagePath = [[NSString alloc] initWithString:[self parseComicImage:_comicModel.contentHTML]];
        
        for (id linkData in entry[@"link"]) {
            if ([linkData[@"rel"] isEqualToString:@"alternate"]) {
                NSString *link = linkData[@"href"];
                _comicModel.link = [[NSString alloc] initWithStringNeverNil:link];
            }
        }
        //[_comicModel retain];
        [comicModelList addObject:_comicModel];
    }
    
    return comicModelList;
}

- (NSArray*)getComicList{
    return comicList;
}

-(id)init{
    self = [super init];
    
    if (self) {
        [self getComicJson];
    }
    
    return self;
}

-(NSString*)parseComicImage:(NSString*)HTMLstr{
    
    NSError *error = nil;
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:HTMLstr error:&error];
    
    if (error) {
        NSLog(@"error: %@",error);
    }
    
    HTMLNode *node = [parser body];
    
    NSArray *list = [node findChildTags:@"img"];
    HTMLNode *n =[list objectAtIndex:0];
    NSString *imgSrc = [n getAttributeNamed:@"src"];
    
    
    return imgSrc;
}

@end
