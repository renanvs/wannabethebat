//
//  WBBDownloadManager.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 01/05/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#define comicImageDir @"comicImages"

#import <Foundation/Foundation.h>

@interface WBBDownloadManager : NSObject

+(id)sharedInstance;

-(BOOL)downloadComicImage:(NSString*)imageUrl;
-(UIImage*)getThumbImageByModel:(ComicModel*)model;
-(UIImage*)getComicImageByModel:(ComicModel*)model;
-(void)downloadComicList:(NSArray*)list;
@end
