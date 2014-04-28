//
//  ComicModel.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicModel : NSObject{
    
    NSString *categoryTerm;
    NSString *contentHTML;
    NSString *identifier;
    NSString *link;
    NSString *thumbURI;
    NSString *publishedDateStr;
    NSString *updatedDateStr;
    NSString *title;
    
}

@property (nonatomic, assign) NSString *categoryTerm;
@property (nonatomic, assign) NSString *contentHTML;
@property (nonatomic, assign) NSString *identifier;
@property (nonatomic, assign) NSString *link;
@property (nonatomic, assign) NSString *thumbURI;
@property (nonatomic, assign) NSString *publishedDateStr;
@property (nonatomic, assign) NSString *updatedDateStr;
@property (nonatomic, assign) NSString *title;

@end
