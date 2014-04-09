//
//  Tank.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "Tank.h"
#import "Constants.h"

@implementation Tank

- (id)init
{
    self = [super init];
    
    if (self){

    }
    
	return self;
}

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndName:(NSString *) name{
    
    self = [super init];
    
    if (self){
        _level = 0;
        _health = 100;        
        self.name = name;
        
        self.body = [[LogicDisplayItem alloc] initWithPosition:pos AndAngle:angle AndType:CCUnitType_Tank AndOwner:self];
        self.cannon = [[LogicDisplayItem alloc] initWithPosition:pos AndAngle:angle AndType:CCUnitType_Cannon AndOwner:self];
        self.radarLaser = [[LogicDisplayItem alloc] initWithPosition:pos AndAngle:angle AndType:CCUnitType_RadarLaser AndOwner:self];

    }
    
    return self;
}

//Should based on level
- (CGFloat)getRadarRange{
    return 150;
}

@end
