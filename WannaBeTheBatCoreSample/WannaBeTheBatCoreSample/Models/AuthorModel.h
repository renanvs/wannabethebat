//
//  AuthorModel.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 28/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorModel : NSObject{
    NSString *name;
    NSString *mail;
    NSString *imageSrc;
    NSString *URI;
}

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *mail;
@property (nonatomic, assign) NSString *imageSrc;
@property (nonatomic, assign) NSString * URI;

@end
