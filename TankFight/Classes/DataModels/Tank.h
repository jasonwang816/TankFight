//
//  Tank.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayItem.h"

@interface Tank :NSObject

@property (nonatomic) NSString * name;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger health;

@property (nonatomic) DisplayItem * body;
@property (nonatomic) DisplayItem * cannon;
@property (nonatomic) DisplayItem * radar;

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndName:(NSString *) name;

- (CGFloat)getRadarRange;
@end
