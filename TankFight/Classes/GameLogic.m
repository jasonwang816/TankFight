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

static NSUInteger nextUIItemID = 0;

+ (NSUInteger)getNextUIItemID{
    return nextUIItemID++;
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
        _logicDisplayItems = [[NSMutableSet alloc] init];
        
    }
    
    return self;
}

- (void)addLogicDisplayItem:(LogicDisplayItem *)item{
    [_logicDisplayItems addObject:item];
}

- (void)removeLogicDisplayItem:(LogicDisplayItem *)item{
    [_logicDisplayItems removeObject:item];
}

@end
