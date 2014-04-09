//
//  LogicDisplayItem.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "DisplayItem.h"
#import "Constants.h"
#import "GameLogic.h"

@implementation LogicDisplayItem

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndType:(CCUnitType)type AndOwner:(Tank *)owner{
    
    self = [super init];
    
    if (self){
        _position = pos;
        _rotation = angle;
        _itemType = type;
        _owner = owner;
        _itemID = [GameLogic getNextUIItemID];
    }
    
    return self;
}

@end
