//
//  ExItem.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
//#import "DisplayItem.m"

@class LogicDisplayItem;

@interface ExItem : NSObject

@property (nonatomic) NSUInteger itemID;
@property (nonatomic) CCUnitType itemType;

@property (nonatomic) CGPoint position;
@property (nonatomic) float rotation;

//- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndType:(CCUnitType)type AndID:(NSUInteger *)itemID;
- (id)initWithLogicDisplayItem:(LogicDisplayItem * )displayItem;

@end
