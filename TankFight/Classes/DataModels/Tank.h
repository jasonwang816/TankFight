//
//  Tank.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayItem.h"

@class LogicDisplayItem;

@interface Tank :NSObject

@property (nonatomic) NSString * name;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger health;

@property (nonatomic) LogicDisplayItem * body;
@property (nonatomic) LogicDisplayItem * cannon;
@property (nonatomic) LogicDisplayItem * radarLaser;

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndName:(NSString *) name;

- (CGFloat)getRadarRange;
@end
