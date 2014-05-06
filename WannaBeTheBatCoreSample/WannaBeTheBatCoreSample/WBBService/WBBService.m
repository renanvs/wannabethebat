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
#import "WBBDownloadManager.h"

@implementation WBBService
@synthesize authorModel;

SynthensizeSingleTon(WBBService)

-(id)init{
    self = [super init];
    
    if (self) {
        context = [[WBBDatabaseService sharedInstance] context];
        [WBBInternetService sharedInstance];
        [self addObservers];
        [self startLoadContents];
    }
    
    return self;
}

-(void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetEnable) name:internetMobile object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetEnable) name:internetWifi object:nil];
}

-(void)startLoadContents{
    BOOL hasInternet = [[WBBInternetService sharedInstance] hasInternet];
    
    if (YES) {
        [self getComicJson];
    }else if([[WBBDatabaseService sharedInstance]hasContentInDatabase]){
        [self loadContentInDatabase];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Atenção" message:@"É necessario a conexão com a internet para baixar o conteudo pela primeira vez" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        waitingForInternet = YES;
    }
}

-(void)internetEnable{
    if (waitingForInternet) {
        [self startLoadContents];
    }
}

-(void)loadContentInDatabase{
    authorModel = [[WBBDatabaseService sharedInstance] getAuthor];
    comicList = [[NSMutableArray alloc] initWithArray:[[WBBDatabaseService sharedInstance] getComicList]];
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
        NSLog(@"error: feed error");
        return;
    }
    NSLog(@"Feed Downloaded");
    
    [self setJsonAuthorToModel:[feed[@"author"] objectAtIndex:0]];
    [authorModel retain];
    
    comicList = [[NSArray alloc] initWithArray:[self setJsonEntryToModelList:feed[@"entry"]]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationComicListUpdated object:nil];
    
    [context save:nil];
    NSLog(@"Donwloaded Contents, send updated list notification");
    //11 9 6228 6209 tim
}

-(void)setJsonAuthorToModel:(id)jsonAuthor{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AuthorModel" inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease];
    request.entity = entity;
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    if (result) {
        authorModel = [result lastObject];
    }else{
        authorModel = [(AuthorModel*)[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    }
    
    authorModel.name = jsonAuthor[@"name"][@"$t"];
    authorModel.url = jsonAuthor[@"uri"] [@"$t"];
    authorModel.imageSrc = jsonAuthor[@"gd$image"] [@"src"];
    authorModel.mail = jsonAuthor[@"email"] [@"$t"];
}

-(NSArray*)setJsonEntryToModelList:(id)jsonEntry{
    
    NSArray *entryList = (NSArray*)jsonEntry;
    
    NSMutableArray *comicModelToDownload = [[NSMutableArray alloc] init];
    NSMutableArray *comicModelList = [[NSMutableArray alloc] init];
    
    if ([[WBBDatabaseService sharedInstance] hasComicContentInDatabase]) {
        for (NSDictionary *entry in entryList) {
            NSString *identifier = entry[@"id"][@"$t"];
            ComicModel *_comicModel = [[WBBDatabaseService sharedInstance] getModelById:identifier];
            if (!_comicModel) {
                _comicModel = [self addEntryToModel:entry HasContext:YES];
                NSLog(@"New Comic: %@", _comicModel.identifier);
            }else{
                BOOL isUpdated = [self updateModelInfo:_comicModel WithEntry:entry];
                if (isUpdated) {
                    [comicModelToDownload addObject:_comicModel];
                    NSLog(@"Update Comic: %@", _comicModel.identifier);
                }
            }
            [comicModelList addObject:_comicModel];
        }
    }else{
        for (NSDictionary *entry in entryList) {
            ComicModel *_comicModel = [self addEntryToModel:entry HasContext:YES];
            [comicModelToDownload addObject:_comicModel];
            [comicModelList addObject:_comicModel];
        }
        NSLog(@"All Contents geted from database");
    }
    
    [self downloadContentsWithList:comicModelToDownload];
    
    NSLog(@"%lu in comicList", (unsigned long)comicModelList.count);
    NSLog(@"%lu to download", (unsigned long)comicModelToDownload.count);
    
    return comicModelList;
}

-(ComicModel*)addEntryToModel:(NSDictionary*)entry HasContext:(BOOL)hasContext{
    NSManagedObjectContext *_context = hasContext ? context : nil;
    NSEntityDescription *entity = [NSEntityDescription entityForName:ModelComic inManagedObjectContext:context];
    ComicModel *_comicModel = [(ComicModel*)[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:_context];
    
    NSString *categoryTerm = [entry[@"category"] lastObject][@"term"];
    //_comicModel.categorie = [self getOrSetCategory:categoryTerm WithContext:hasContext];
    _comicModel.categorie = nil;
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

    return _comicModel;
}

-(CategoryModel*)getOrSetCategory:(NSString*)categoryTerm WithContext:(BOOL)hasContext{
    NSManagedObjectContext *_context = hasContext ? context : nil;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryModel" inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease];
    request.entity = entity;
    NSArray *result = [_context executeFetchRequest:request error:nil];
    
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

-(BOOL)updateModelInfo:(ComicModel*)model WithEntry:(NSDictionary*)_entry{
    ComicModel *tempComicModel = [self addEntryToModel:_entry HasContext:NO];
    if (![tempComicModel.htmlContent isEqualToString:model.htmlContent] ||
        ![tempComicModel.url isEqualToString:model.url] ||
        ![tempComicModel.thumbUrl isEqualToString:model.thumbUrl] ||
        ![tempComicModel.dateUpdated isEqualToString:model.dateUpdated] ||
        ![tempComicModel.title isEqualToString:model.title] ||
        ![tempComicModel.imagePath isEqualToString:model.imagePath]) {
       
        model.htmlContent      = tempComicModel.htmlContent;
        model.url              = tempComicModel.url;
        model.thumbUrl         = tempComicModel.thumbUrl;
        model.dateUpdated      = tempComicModel.dateUpdated;
        model.title            = tempComicModel.title;
        model.imagePath        = tempComicModel.imagePath;
        
        return YES;
    }
    
    return NO;
}

-(void)downloadContentsWithList:(NSArray*)listToDownload{
    [[WBBDownloadManager sharedInstance] downloadComicList:listToDownload];
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
    
    ///temp
    NSString *lastPath = [imgSrc lastPathComponent];
    imgSrc = [NSString stringWithFormat:@"http://localhost/~renansilva/temp/image/%@",lastPath];
    imgSrc = [imgSrc stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    ///
    
    return imgSrc;
}

- (UIImage*)getThumbImageWithComicModel:(ComicModel*)model{
    return [[WBBDownloadManager sharedInstance] getThumbImageByModel:model];
}

- (UIImage*)getComicImageWithComicModel:(ComicModel*)model{
    return [[WBBDownloadManager sharedInstance] getComicImageByModel:model];
}

@end
