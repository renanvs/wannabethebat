//
//  CoreDataService.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 29/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataService : NSObject{
    NSManagedObjectContext *context;
}

@property (readonly ,strong) NSManagedObjectContext *context;

+(id)sharedInstance;

@end
