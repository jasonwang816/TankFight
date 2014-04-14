//
//  ExItem.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "ExItem.h"
#import "DisplayItem.h"

@implementation ExItem

- (id)initWithLogicDisplayItem:(LogicDisplayItem * )displayItem{
    self = [super init];
    
    if (self){
        _position = displayItem.position;
        _rotation = displayItem.rotation;
        _itemType = displayItem.itemType;
        _itemID = displayItem.itemID;
    }
    
    return self;
}

//- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndType:(CCUnitType)type AndID:(NSUInteger *)itemID{
//    
//    self = [super init];
//    
//    if (self){
//        _position = pos;
//        _rotation = angle;
//        _itemType = type;
//        _itemID = itemID;
//    }
//    
//    return self;
//}

@end
