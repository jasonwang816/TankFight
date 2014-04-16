//
//  UIFrame.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "UIFrame.h"
#import "ExItem.h"
#import "DisplayItem.h"


@implementation UIFrame

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeDouble:self.frameTime forKey:@"frameTime"];
    [encoder encodeObject:self.logicDisplayItems forKey:@"logicDisplayItems"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.frameTime = [decoder decodeDoubleForKey:@"frameTime"];
        self.logicDisplayItems = [decoder decodeObjectForKey:@"logicDisplayItems"];
    }
    return self;
}

- (id)initWithFrameTime:(NSTimeInterval)frameTime AndDisplayItems:(NSMutableArray *)displayItems{
    
    self = [super init];
    
    if (self){
        self.frameTime = frameTime;
        self.logicDisplayItems = [[NSMutableDictionary alloc] initWithCapacity:displayItems.count];
        
        for(LogicDisplayItem * item in displayItems)
        {
             ExItem * eItem = [[ExItem alloc] initWithLogicDisplayItem:item];
             [self.logicDisplayItems setObject:eItem forKey:@(eItem.itemID)];
        };
        
    }
    
    return self;
}

+ (id)initWithFrame:(UIFrame *)first AndFrame:(UIFrame *)second atRatio:(double)ratio{

    if (ratio >= 1)
        return second;
    
    //if new item added or item dismissed, always return second one
    //NOTE: always add new frame when item added or item dismissed.
    if (second.logicDisplayItems.count != first.logicDisplayItems.count)
        return second;

    UIFrame * frame = [[UIFrame alloc] init];
    
    frame.frameTime = first.frameTime + (second.frameTime - first.frameTime) * ratio;
    frame.logicDisplayItems = [[NSMutableDictionary alloc] initWithCapacity:first.logicDisplayItems.count];
    
    for(id eItemID in first.logicDisplayItems)
    {
        ExItem * eItem = [first.logicDisplayItems objectForKey:eItemID];
        ExItem * nItem = [second.logicDisplayItems objectForKey:eItemID];
        if (nItem) //item disappeared, like bullet
        {
            NSUInteger itemID = eItem.itemID;
            CCUnitType itemType = eItem.itemType;
            CGFloat x = [self getValueBetweenA:eItem.position.x AndB:nItem.position.x AtRatio:ratio];
            CGFloat y = [self getValueBetweenA:eItem.position.y AndB:nItem.position.y AtRatio:ratio];
            CGPoint position = CGPointMake(x, y);
            float rotation = [self getValueBetweenA:eItem.rotation AndB:nItem.rotation AtRatio:ratio];
            
            ExItem * newItem = [[ExItem alloc] initWithPosition:position AndAngle:rotation AndType:itemType AndID:itemID];
            
            [frame.logicDisplayItems setObject:newItem forKey:@(newItem.itemID)];
        }else{
            [frame.logicDisplayItems setObject:eItem forKey:@(eItem.itemID)];
        }

    };

    return frame;
}

+ (float)getValueBetweenA:(float)a AndB:(float)b AtRatio:(double)r{
    return a + (b - a) * r;
}

- (NSString *)description
{
    ExItem * e = (ExItem *)[self.logicDisplayItems objectForKey:@(2)];
	return [NSString stringWithFormat:@"time: %f; count %lu, item2(tank): position [%@]",
            self.frameTime, self.logicDisplayItems.count,
            NSStringFromCGPoint( e.position)];
}

@end
