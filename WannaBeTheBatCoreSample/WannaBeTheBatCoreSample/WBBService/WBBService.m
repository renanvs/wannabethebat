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
#import "CoreDataService.h"

@implementation WBBService
@synthesize authorModel;

SynthensizeSingleTon(WBBService)

-(id)init{
    self = [super init];
    
    if (self) {
        [WBBInternetService sharedInstance];
        context = [[CoreDataService sharedInstance] context];
        
        [self getComicJson];
    }
    
    return self;
}

-(void)getComicJson{
    // @"http://www.wannabethebat.com/feeds/posts/default?alt=json";
    NSString *urlStr = @"http://localhost/~renansilva/temp/default.json";
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operationManager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id json){
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
    [context save:nil];
}

-(AuthorModel*)setJsonAuthorToModel:(id)jsonAuthor{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AuthorModel" inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease];
    request.entity = entity;
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    if (result) {
        AuthorModel *_authorModel = [result lastObject];
        return _authorModel;
    }
    
    AuthorModel *_authorModel = [(AuthorModel*)[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    _authorModel.name = jsonAuthor[@"name"][@"$t"];
    _authorModel.url = jsonAuthor[@"uri"] [@"$t"];
    _authorModel.imageSrc = jsonAuthor[@"gd$image"] [@"src"];
    _authorModel.mail = jsonAuthor[@"email"] [@"$t"];
    
    [context insertObject:_authorModel];
    return _authorModel;
}

-(NSArray*)setJsonEntryToModelList:(id)jsonEntry{
    
    NSArray *entryList = (NSArray*)jsonEntry;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComicModel" inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"datePublished" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    request.entity = entity;
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    NSMutableArray *comicModelList = nil;
    
    if (result && result.count > 0) {
        comicModelList = [[NSMutableArray alloc] initWithArray:result];
        return comicModelList;
    }
    
    comicModelList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *entry in entryList) {
        ComicModel *_comicModel = [(ComicModel*)[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        
        NSString *categoryTerm = [entry[@"category"] lastObject][@"term"];
        _comicModel.categorie = [self getOrSetCategory:categoryTerm];
        _comicModel.htmlContent = entry[@"content"][@"$t"];
        _comicModel.identifier = entry[@"id"][@"$t"];
        _comicModel.thumbUrl = entry[@"media$thumbnail"][@"url"];
        _comicModel.datePublished = entry[@"published"][@"$t"];
        _comicModel.dateUpdated = entry[@"updated"][@"$t"];
        _comicModel.title = entry[@"title"][@"$t"];
        _comicModel.imagePath = [[NSString alloc] initWithString:[self parseComicImage:_comicModel.htmlContent]];
        
        for (id linkData in entry[@"link"]) {
            if ([linkData[@"rel"] isEqualToString:@"alternate"]) {
                _comicModel.url = linkData[@"href"];
            }
        }
        
        [context insertObject:_comicModel];
        [comicModelList addObject:_comicModel];

    }
    
    return comicModelList;
}

-(CategoryModel*)getOrSetCategory:(NSString*)categoryTerm{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryModel" inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease];
    request.entity = entity;
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    if (result) {
        for (CategoryModel *categoryModel in result) {
            if ([categoryModel.title isEqualToString:categoryTerm]) {
                return categoryModel;
            }
        }
    }
    
    CategoryModel *categoryModel = [(CategoryModel*)[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    categoryModel.title = categoryTerm;
    [context insertObject:categoryModel];
    return categoryModel;
    
}

- (NSArray*)getComicList{
    return comicList;
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
