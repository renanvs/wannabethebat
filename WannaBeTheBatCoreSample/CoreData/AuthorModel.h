//
//  AuthorModel.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 02/05/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AuthorModel : NSManagedObject

@property (nonatomic, retain) NSString * imageSrc;
@property (nonatomic, retain) NSString * mail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;

@end
