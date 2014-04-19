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

//update from physics
- (void)physicsCollisionWith:(LogicDisplayItem *)item
{
    //bullet
    if (item.itemType == CCUnitType_Bullet) {
        self.tankInfo.health -= 10;
        NSLog(@"physicsCollisionWith: %@ hit by bullet. [health:%ld]", self.name, (long)self.tankInfo.health);
    }
    
    //other tank;
    if (item.itemType == CCUnitType_Tank) {
        NSLog(@"physicsCollisionWith: %@ Found : %@", self.name, item.owner.name);
    }
    //update intel
}


//Should based on level
- (CGFloat)getRadarRange{
    return 150;
}

@end
