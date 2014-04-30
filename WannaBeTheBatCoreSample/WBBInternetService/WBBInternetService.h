//
//  WBBInternetService.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 29/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface WBBInternetService : NSObject{
    Reachability *reach;
    BOOL hasInternet;
    BOOL isMobileNetwork;
    BOOL isWifiNetwork;
}

@property (nonatomic, assign) BOOL hasInternet;
@property (nonatomic, assign) BOOL isMobileNetwork;
@property (nonatomic, assign) BOOL isWifiNetwork;

+(id)sharedInstance;

@end
