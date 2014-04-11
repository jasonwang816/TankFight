//
//  GameLogic.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "GameLogic.h"
#import "Tank.h"

@implementation GameLogic

static NSUInteger nextUIItemID = 1; //start with 1.

+ (NSUInteger)getNextUIItemID{
    NSUInteger num = nextUIItemID++;
    NSLog(@"getNextUIItemID : %lu", (unsigned long)num);
    return num;
}


- (id) init
{
    self = [super init];
    
    if (self){
        //game field
        _gameField = [[GameField alloc] initWithPosition:CGPointMake(0, 0) AndAngle:0 AndSize:CGSizeMake(480, 320)];
        
        //tanks
        Tank * tank;
        self.tanks = [[NSMutableArray alloc] init];
        
        tank = [[Tank alloc] initWithPosition:homeTankPosition AndAngle:90 AndName:@"Home"];
        [_tanks addObject:tank];
        
        tank = [[Tank alloc] initWithPosition:visitorTankPosition AndAngle:90 AndName:@"visitor"];
        [_tanks addObject:tank];
        
        //logicDisplayItems
        _logicDisplayItems = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}

//- (LogicDisplayItem *)buildLogicDisplayItem:(LogicDisplayItem *)item{
//    [_logicDisplayItems addObject:item];
//}

- (void)addLogicDisplayItem:(LogicDisplayItem *)item{
    [_logicDisplayItems setObject:item forKey:@(item.itemID)];
    [self.delegate addedLogicDisplayItem:item];
}

- (void)removeLogicDisplayItem:(LogicDisplayItem *)item{
    [_logicDisplayItems removeObjectForKey:@(item.itemID)];
    [self.delegate removedLogicDisplayItem:item];
}

- (void)explodeAt:(CGPoint)position{
    [self.delegate explodedAt:position];
}

@end
