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

//-(void)encodeWithCoder:(NSCoder *)encoder{
//    [encoder encodeCGPoint:self.position forKey:@"p"];
//    [encoder encodeDouble:self.rotation forKey:@"r"];
//    [encoder encodeInt:self.itemType forKey:@"t"];
//    [encoder encodeInt64:self.itemID forKey:@"i"];
//    
//}
//
//- (id)initWithCoder:(NSCoder *)decoder {
//    if (self = [super init]) {
//        
//        self.position = [decoder decodeCGPointForKey:@"p"];
//        self.rotation = [decoder decodeDoubleForKey:@"r"];
//        self.itemType = [decoder decodeIntForKey:@"t"];
//        self.itemID = [decoder decodeInt64ForKey:@"i"];
//    }
//    return self;
//}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeCGPoint:self.position forKey:@"position"];
    [encoder encodeDouble:self.rotation forKey:@"rotation"];
    [encoder encodeInt:self.itemType forKey:@"itemType"];
    [encoder encodeInt64:self.itemID forKey:@"itemID"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        self.position = [decoder decodeCGPointForKey:@"position"];
        self.rotation = [decoder decodeDoubleForKey:@"rotation"];
        self.itemType = [decoder decodeIntForKey:@"itemType"];
        self.itemID = [decoder decodeInt64ForKey:@"itemID"];
    }
    return self;
}

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

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndType:(CCUnitType)type AndID:(NSUInteger *)itemID{
    
    self = [super init];
    
    if (self){
        _position = pos;
        _rotation = angle;
        _itemType = type;
        _itemID = itemID;
    }
    
    return self;
}

@end
