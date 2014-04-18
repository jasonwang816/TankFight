//
//  LogicDisplayItem.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "DisplayItem.h"
#import "Constants.h"
//#import "GameLogic.h"
#import "Game.h"

@implementation LogicDisplayItem

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

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndType:(CCUnitType)type AndOwner:(Tank *)owner{
    
    self = [super init];
    
    if (self){
        _position = pos;
        _rotation = angle;
        _itemType = type;
        _owner = owner;
        _itemID = [Game getNextUIItemID];
    }
    
    return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"id: %d; type %d; item: position [%@]",
            self.itemID, self.itemType, NSStringFromCGPoint( self.position)];
}
@end
