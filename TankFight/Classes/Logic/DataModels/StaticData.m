//
//  StaticData.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-18.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "StaticData.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"

@implementation StaticData{
    NSArray * colors;
}

static StaticData *_instance = nil;

+ (StaticData *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[StaticData alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    if (_instance) return _instance;
    
    self = [super init];
    
    if (self){
//        NSDictionary * gaInfo = @{
//                                  @(GATrack_TotalNumberOfResults):@(totalResultCount),
//                                  @(GATrack_AdPosition):@(adPos),
//                                  @(GATrack_SortOrder):(sortString),
//                                  @(GATrack_Ad_Source):@(newSource),
//                                  @(GATrack_ShowCPO):(cpoString),
//                                  @(GATrack_NumberOfSameUpsell):@([self getNumberOfSameUpsellInPage:index VehicleSource:newSource])
//                                  };
        
        colors = [[NSArray alloc] initWithObjects: [CCColor redColor] , [CCColor blueColor], nil];
    }
    
    return self;

}




@end
