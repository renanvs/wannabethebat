//
//  ComicModel.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 02/05/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryModel;

@interface ComicModel : NSManagedObject

@property (nonatomic, retain) NSString * datePublished;
@property (nonatomic, retain) NSString * dateUpdated;
@property (nonatomic, retain) NSNumber * downloaded;
@property (nonatomic, retain) NSString * htmlContent;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * thumbUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) CategoryModel *categorie;

@end
