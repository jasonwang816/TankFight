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
    NSDictionary * specData;
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
        specData = @{
                      @(TankSpec_Demage):@(10),
                      @(TankSpec_Defence):@(1),
                      @(TankSpec_MovingSpeed):@(30),
                      @(TankSpec_TurningSpeed):@(180),
                      @(TankSpec_BulletSpeed):@(200),
                      @(TankSpec_RadarSpeed):@(180),
                      @(TankSpec_RadarRange):@(200)
                  };
        
        colors = [[NSArray alloc] initWithObjects: [CCColor redColor] , [CCColor blueColor], nil];
    }
	
    return self;

}

- (CGFloat)getTankSpec:(Tank *)tank Spec:(TankSpec)spec{
    CGFloat value = [[specData objectForKey:@(spec)] floatValue];
    
    if ([tank.tankInfo.specLevel objectForKey:@(spec)]) {
        value *= [[tank.tankInfo.specLevel objectForKey:@(spec)] floatValue];
    }
    
    return value;
}


@end
