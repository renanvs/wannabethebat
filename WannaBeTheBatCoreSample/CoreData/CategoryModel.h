//
//  CategoryModel.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 02/05/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ComicModel;

@interface CategoryModel : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *comics;
@end

@interface CategoryModel (CoreDataGeneratedAccessors)

- (void)addComicsObject:(ComicModel *)value;
- (void)removeComicsObject:(ComicModel *)value;
- (void)addComics:(NSSet *)values;
- (void)removeComics:(NSSet *)values;

@end
