//
//  LogicDisplayItem.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "ItemInfo.h"
#import "Tank.h"

@class Tank;

@interface LogicDisplayItem : NSObject

@property (nonatomic) NSUInteger itemID;
@property (nonatomic) CCUnitType itemType;
@property (nonatomic, weak) Tank * owner;

@property (nonatomic) CGPoint position;
@property (nonatomic) float rotation;

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndType:(CCUnitType)type AndOwner:(Tank *)owner;

@end
