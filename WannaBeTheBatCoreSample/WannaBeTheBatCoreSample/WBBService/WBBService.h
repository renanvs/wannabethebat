//
//  WBBService.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorModel.h"
#import "ComicModel.h"

@interface WBBService : NSObject{
    NSArray *comicList;
    AuthorModel *authorModel;
}

@property (assign, nonatomic) AuthorModel *authorModel;

+ (id) sharedInstance;

@end
