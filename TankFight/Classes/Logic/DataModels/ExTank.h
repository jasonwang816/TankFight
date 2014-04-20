//
//  ExTank.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//
//  Holding data used for exchange between players and AI. only logic data, not for UI

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "ExItem.h"

@interface ExTank : NSObject<NSCoding>

//exchangable data
@property (nonatomic) NSString * name;
@property (nonatomic) NSInteger team;
@property (nonatomic) CGFloat health;
@property (nonatomic) CGPoint position;
@property (nonatomic) float rotation;

@property (nonatomic) NSMutableDictionary * specLevel;

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndName:(NSString *)name AndTeam:(NSInteger)team;

@end
