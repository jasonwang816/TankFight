//
//  Tank.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayItem.h"
#import "ExTank.h"

@class LogicDisplayItem;

@interface Tank :NSObject<NSCoding>
//exchange data
@property (nonatomic) NSInteger tankID;
@property (nonatomic) ExTank * tankInfo;

@property (nonatomic) LogicDisplayItem * body;
@property (nonatomic) LogicDisplayItem * cannon;
@property (nonatomic) LogicDisplayItem * radarLaser;

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndInfo:(ExTank *) info;

- (void)physicsCollisionWith:(LogicDisplayItem *)item;

- (CGFloat)getRadarRange;
@end
