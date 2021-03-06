//
//  Tank.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "Tank.h"
#import "Constants.h"
#import "StaticData.h"

@implementation Tank
-(void)encodeWithCoder:(NSCoder *)encoder{

    [encoder encodeInteger:self.tankID forKey:@"tankID"];
    [encoder encodeObject:self.tankInfo forKey:@"tankInfo"];
    [encoder encodeInteger:self.colorID forKey:@"colorID"];
//    [encoder encodeObject:self.body forKey:@"body"];
//    [encoder encodeObject:self.cannon forKey:@"cannon"];
//    [encoder encodeObject:self.radarLaser forKey:@"radarLaser"];

    //TODO:other properties:

}


- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {

        self.tankID = [decoder decodeIntegerForKey:@"tankID"];
        self.tankInfo = [decoder decodeObjectForKey:@"tankInfo"];
        self.colorID = [decoder decodeIntegerForKey:@"colorID"];
//        self.body = [decoder decodeObjectForKey:@"body"];
//        self.cannon = [decoder decodeObjectForKey:@"cannon"];
//        self.radarLaser = [decoder decodeObjectForKey:@"radarLaser"];
        
        CGPoint pos = self.tankInfo.position;
        CGFloat angle = self.tankInfo.rotation;
        
        self.body = [[LogicDisplayItem alloc] initWithPosition:pos AndAngle:angle AndType:CCUnitType_Tank AndOwner:self];
        self.cannon = [[LogicDisplayItem alloc] initWithPosition:pos AndAngle:angle AndType:CCUnitType_Cannon AndOwner:self];
        self.radarLaser = [[LogicDisplayItem alloc] initWithPosition:pos AndAngle:angle AndType:CCUnitType_RadarLaser AndOwner:self];
        
    }
    return self;
}

//TODO: change to (id)initWithInfo:(ExTank *) info{
- (id)initWithInfo:(ExTank *) info{
    
    self = [super init];
    
    if (self){
        //TODO: tankid, colorid;
        self.tankInfo = info;
        
        CGPoint pos = self.tankInfo.position;
        CGFloat angle = self.tankInfo.rotation;
        
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
        NSLog(@"physicsCollisionWith: %@ hit by bullet. [health:%f]", self.tankInfo.name, self.tankInfo.health);
    }
    
    //other tank;
    if (item.itemType == CCUnitType_Tank) {
        NSLog(@"physicsCollisionWith: %@ Found : %@", self.tankInfo.name, item.owner.tankInfo.name);
    }
    //update intel
}


//Spec
- (CGFloat)movingSpeed{
    return [[StaticData sharedInstance] getTankSpec:self Spec:TankSpec_MovingSpeed];
}

- (CGFloat)turningSpeed{
    return [[StaticData sharedInstance] getTankSpec:self Spec:TankSpec_TurningSpeed];
}

- (CGFloat)demage{
    return [[StaticData sharedInstance] getTankSpec:self Spec:TankSpec_Demage];
}

- (CGFloat)defence{
    return [[StaticData sharedInstance] getTankSpec:self Spec:TankSpec_Defence];
}

- (CGFloat)bulletSpeed{
    return [[StaticData sharedInstance] getTankSpec:self Spec:TankSpec_BulletSpeed];
}

- (CGFloat)radarSpeed{
    return [[StaticData sharedInstance] getTankSpec:self Spec:TankSpec_RadarSpeed];
}
- (CGFloat)radarRange{
    return [[StaticData sharedInstance] getTankSpec:self Spec:TankSpec_RadarRange];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"[Tank : %@]", self.tankInfo];
}

@end
