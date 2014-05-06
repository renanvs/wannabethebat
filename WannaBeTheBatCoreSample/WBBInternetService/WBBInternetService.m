//
//  WBBInternetService.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 29/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "WBBInternetService.h"

@implementation WBBInternetService

@synthesize hasInternet, isMobileNetwork, isWifiNetwork;

SynthensizeSingleTon(WBBInternetService)

-(id)init{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusUpdated:) name:kReachabilityChangedNotification object:nil];
        reach = [Reachability reachabilityForInternetConnection];
        [reach startNotifier];
        [self networkStatusUpdated:nil];
    }
    
    return self;
}

-(void)networkStatusUpdated:(NSNotification*)notification{
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == NotReachable) {
        hasInternet = NO;
        isWifiNetwork = NO;
        isMobileNetwork = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:internetOff object:nil];
    }else if(status == ReachableViaWWAN){
        hasInternet = YES;
        isWifiNetwork = NO;
        isMobileNetwork = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:internetMobile object:nil];
    }else{
        hasInternet = YES;
        isWifiNetwork = YES;
        isMobileNetwork = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:internetWifi object:nil];
    }
}


@end
