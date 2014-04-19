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
-(void)encodeWithCoder:(NSCoder *)encoder{

    [encoder encodeInteger:self.tankID forKey:@"tankID"];
    [encoder encodeObject:self.tankInfo forKey:@"tankInfo"];
    [encoder encodeObject:self.body forKey:@"body"];
    [encoder encodeObject:self.cannon forKey:@"cannon"];
    [encoder encodeObject:self.radarLaser forKey:@"radarLaser"];

    //TODO:other properties:

}

//[encoder en
//self. = [decoder de
//:self. f
//F
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {

        self.tankID = [decoder decodeIntegerForKey:@"tankID"];
        self.tankInfo = [decoder decodeObjectForKey:@"tankInfo"];
        self.body = [decoder decodeObjectForKey:@"body"];
        self.cannon = [decoder decodeObjectForKey:@"cannon"];
        self.radarLaser = [decoder decodeObjectForKey:@"radarLaser"];
        
    }
    return self;
}


- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndInfo:(ExTank *) info{
    
    self = [super init];
    
    if (self){
        self.tankInfo = info;
        
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
        NSLog(@"physicsCollisionWith: %@ hit by bullet. [health:%ld]", self.tankInfo.name, (long)self.tankInfo.health);
    }
    
    //other tank;
    if (item.itemType == CCUnitType_Tank) {
        NSLog(@"physicsCollisionWith: %@ Found : %@", self.tankInfo.name, item.owner.tankInfo.name);
    }
    //update intel
}


//Should based on level
- (CGFloat)getRadarRange{
    return 150;
}

@end
